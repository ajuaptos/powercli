# PowerCLI script to Set VAAI variables to all hosts in the cluster
# Only does this to hosts marked as "Connected"
 
# Define our settings
$vcserver = "vcenter"
$clustername = "cluster"

# Connect to vCenter server
Connect-VIServer $vcserver
 
# Do the work
$hostsincluster = Get-Cluster $clustername | Get-VMHost -State "Connected"
ForEach ($vmhost in $hostsincluster)
{
    ""
    "Changing host: $vmhost"

	Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name DataMover.HardwareAcceleratedMove -Value 1
	Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name DataMover.HardwareAcceleratedInit -Value 1
	Set-VMHostAdvancedConfiguration -VMHost $VMHost -Name VMFS3.HardwareAcceleratedLocking -Value 1

	Get-VMHostAdvancedConfiguration -vmhost $vmhost -Name DataMover*, VMFS3.HardwareAcc* 
}
"All Done. Check to ensure no errors were reported above."
