#Requires -Version 3
function Connect-Cohesity
{
    <#  
            .SYNOPSIS
            Connects to Cohesity and retrieves a token value for authentication
            .DESCRIPTION
            The Connect-Cohesity function is used to connect to the Cohesity RESTful API and supply credentials to the /login method. Cohesity then returns a unique token to represent the user's credentials for subsequent calls. Acquire a token before running other Cohesity cmdlets.
            .EXAMPLE
            Connect-Cohesity -Server cohesity-ip admin This will connect to Cohesity with a username of "admin" to the IP address 10.1.107.231. The prompt will request a secure password.
            .EXAMPLE
            Connect-Cohesity -Server cohesity-ip -Username admin -Password (ConvertTo-SecureString "secret" -asplaintext -force)
            If you need to pass the password value in the cmdlet directly, use the ConvertTo-SecureString function.
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Cohesity FQDN or IP address')]
        [ValidateNotNullorEmpty()]
        [String]$Server,
        [Parameter(Mandatory = $true,Position = 1,HelpMessage = 'Cohesity username')]
        [ValidateNotNullorEmpty()]
        [String]$Username,
       [Parameter(Mandatory = $true,Position = 2,HelpMessage = 'Cohesity password')]
        [ValidateNotNullorEmpty()]
        [SecureString]$Password

    )

    Process {

        # Allow untrusted SSL certs
        Add-Type -TypeDefinition @"
	    using System.Net;
	    using System.Security.Cryptography.X509Certificates;
	    public class TrustAllCertsPolicy : ICertificatePolicy {
	        public bool CheckValidationResult(
	            ServicePoint srvPoint, X509Certificate certificate,
	            WebRequest request, int certificateProblem) {
	            return true;
	        }
	    }
"@
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy

        Write-Verbose -Message 'Build the URI'
        $uri = 'https://'+$Server+'/public/accessTokens'

        Write-Verbose -Message 'Build the JSON body for Basic Auth'
        $credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Password        
        $body = @{
            userId   = $Username
           password = $credentials.GetNetworkCredential().Password
        }

        Write-Verbose -Message 'Submit the token request'
        try 
        {
            $r = Invoke-WebRequest -Uri $uri -Method: Post -Body (ConvertTo-Json -InputObject $body)
        }
        catch 
        {
            throw 'Error connecting to Cohesity server'
        }
        $global:CohesityServer = $Server
        $global:CohesityToken = (ConvertFrom-Json -InputObject $r.Content).token
        Write-Verbose -Message "Acquired token: $global:CohesityToken"
        
        Write-Host -Object 'You are now connected to the Cohesity API.'

        Write-Verbose -Message 'Validate token and build Base64 Auth string'
        $auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($global:CohesityToken+':'))
        $global:CohesityHead = @{
            'Authorization' = "Basic $auth"
        }

    } # End of process
} # End of function

function New-Cohesitymount
{
    <#  
            .SYNOPSIS
            Create a new Live Mount from a protected VM
            .DESCRIPTION
            The New-CohesityMount cmdlet is used to create a Live Mount (clone) of a protected VM and run it in an existing vSphere environment.
           
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Virtual Machine to mount',ValueFromPipeline = $true)]
        [Alias('Name')]
        [ValidateNotNullorEmpty()]
        [String]$VM,
		[Parameter(Mandatory = $true,Position = 0,HelpMessage = 'Job ID',ValueFromPipeline = $true)]
        [Alias('JobID')]
        [ValidateNotNullorEmpty()]
        [String]$JobID,
        [Parameter(Mandatory = $true,Position = 1,HelpMessage = 'Backup date in MM/DD/YYYY HH:MM format',ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        [String]$Date,
        [Parameter(Mandatory = $false,Position = 2,HelpMessage = 'Cohesity FQDN or IP address')]
        [ValidateNotNullorEmpty()]
        [String]$Server = $global:CohesityServer
    )

    Process {

        Write-Verbose -Message 'Validating the Cohesity API token exists'
        if (-not $global:CohesityToken) 
        {
            Write-Warning -Message 'You are not connected to a Cohesity server. Using Connect-Cohesity cmdlet.'
            Connect-Cohesity
        }

        Write-Verbose -Message 'Query Cohesity for the list of protected VM details'
        $uri = 'https://'+$global:CohesityServer+':443/public/ProtectionRuns'
        try 
        {
            $r = Invoke-WebRequest -Uri $uri -Headers $global:CohesityHead -Method Get
            $result = (ConvertFrom-Json -InputObject $r.Content) | Where-Object -FilterScript {
                $_.sourceId -eq $JobID
            }
            if (!$result) 
            {
                throw 'No Job found with that ID.'
            }
            $vmid = $result.id
            $hostid = $result.hostId
        }
        catch 
        {
            throw 'Error connecting to Cohesity server'
        }

        Write-Verbose -Message 'Query Cohesity for the protected VM snapshot list'
        $uri = 'https://'+$global:CohesityServer+':443/snapshot?vm='+$vmid
        try 
        {
            $r = Invoke-WebRequest -Uri $uri -Headers $global:CohesityHead -Method Get
            $result = (ConvertFrom-Json -InputObject $r.Content)
            if (!$result) 
            {
                throw 'No snapshots found for VM.'
            }
        }
        catch 
        {
            throw 'Error connecting to Cohesity server'
        }

        Write-Verbose -Message 'Comparing backup dates to user date'
        $Date = $Date -as [datetime]
        if (!$Date) {throw "You did not enter a valid date and time"}
        foreach ($_ in $result)
            {
            if ((Get-Date $_.date) -lt (Get-Date $Date) -eq $true)
                {
                $vmsnapid = $_.id
                break
                }
            }

        Write-Verbose -Message 'Creating a Live Mount'
        $uri = 'https://'+$global:CohesityServer+':443/job/type/mount'

        $body = @{
            snapshotId     = $vmsnapid
            hostId         = $hostid
            disableNetwork = 'true'
        }

        try 
        {
            $r = Invoke-WebRequest -Uri $uri -Headers $global:CohesityHead -Method Post -Body (ConvertTo-Json -InputObject $body)
            if ($r.StatusCode -ne '200') 
            {
                throw 'Did not receive successful status code from Cohesity for Live Mount request'
            }
            Write-Verbose -Message "Success: $($r.Content)"
        }
        catch 
        {
            throw 'Error connecting to Cohesity server'
        }

    } # End of process
} # End of function

Connect-Cohesity -Server cohesity-ip  -Username admin -Password (ConvertTo-SecureString "secret" -asplaintext -force)
