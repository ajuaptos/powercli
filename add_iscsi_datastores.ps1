#Script to add iSCSI datastores to multiple hosts use the round robin script to ensure roundrobin if no powerpath is used

Connect-VIServer -Server vcenter

#FQDNs or IP addresses of ESXi Hosts to Configure
#Enclose each host in quotes and separate with a comma.
#Example: $ESXiHosts = "192.168.1.1","192.168.1.2"
$ESXiHosts = "host1", "host2", "host3", "host4"
# Prompt for ESXi Root Credentials
#$esxcred = Get-Credential 
 
#Connect to each host defined in $ESXiHosts

Connect-viserver -Server $ESXiHosts -User root -Password password
# Set $targets to the SendTargets you want to add. Enclose each target in quotes and separate with a comma.
# Example: $targets = "192.168.151.10", "192.168.151.11", "192.168.151.12", "192.168.151.13"
#Targets for SAN1 Datacenter1
$targets = "192.168.184.50", "192.168.184.51","192.168.186.50","192.168.186.51"
#Targets for SAN2 Datacenter1
#$targets = "192.168.184.26", "192.168.184.27","192.168.184.28", "10.51.184.29","192.168.186.26","192.168.186.27","192.168.186.28","192.168.186.29"
#Targets for SAN2 Datacenter2
#$targets = "192.168.184.50", "192.168.184.51","192.168.186.50","192.168.186.51"

foreach ($esx in $ESXiHosts) {
  Write-Host "Adding iSCSI SendTargets..." -ForegroundColor Green

  $hba = Get-VMHostHba -VMHost $esx -Type iScsi | Where {$_.Model -eq "iSCSI Software Adapter"}

  foreach ($target in $targets) {
     # Check to see if the SendTarget exist, if not add it
     if (Get-IScsiHbaTarget -IScsiHba $hba -Type Send | Where {$_.Address -cmatch $target}) {
        Write-Host "The target $target does exist on $esx" -ForegroundColor Green
     }
     else {
        Write-Host "The target $target doesn't exist on $esx" -ForegroundColor Red
        Write-Host "Creating $target on $esx ..." -ForegroundColor Yellow
        New-IScsiHbaTarget -IScsiHba $hba -Address $target       
     }
  }
}
Write "`n Done - Disconnecting from $ESXiHosts"
Disconnect-VIServer -Server * -Force -Confirm:$false
Write-Host "Done! Now go manually add the iSCSI vmk bindings to the Software iSCSI Adapter and Resan." -ForegroundColor Green
