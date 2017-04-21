# PowerCLI script to add NFS datasore and changes creates a folder with the host name and changes the syslog variable in the host to write to it
# Only does this to hosts marked as "Connected" and doesn't work on hosts marked as "Maintenance mode"

# Define NFS datastore & Cluster information
$vcserver = vcenter
$clustername = cluster
$folder = folder
$nfshost = NFS host
$nfspath1 = "/esxi_logs"
#Syslog information
$SyslogDatastore = "esxi_logs"
$SyslogFolderName = "ESXi-Syslog"
$SyslogDatastoreLogDir = "[" + $SyslogDatastore + "]"
 
# Connect to vCenter server
Connect-VIServer $vcserver
 
# Do the work for Clusters
$hostsincluster = Get-Cluster $clustername | Get-VMHost 
ForEach ($vmhost in $hostsincluster)
{
    ""
    "Adding NFS Datastores to ESX host: $vmhost"
    "-----------------"
    "nfs01"
   New-Datastore -VMHost $vmhost -Name "esxi_logs" -Nfs -NfsHost $nfshost -Path $nfspath1

# Adding the Syslog
cd vmstore:
cd ./$DefaultVIServer
cd ./$SyslogDatastore
cd ./$SyslogFolderName
mkdir $VMHost.Name
        Write-Host "Created folder: $VMHost.Name"
        $FullLogPath = $SyslogDatastoreLogDir + "/" + $SyslogFolderName + "/" + $VMHost.Name
        Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name "Syslog.global.logDir" -Value $FullLogPath
        Write-Host "Paths set: LogDir = $FullLogPath"

}
"All Done. Check to ensure no errors were reported above."
