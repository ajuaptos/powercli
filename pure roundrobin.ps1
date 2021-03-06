
Connect-VIServer -Server vcenter -User username

$cluster = "Cluster"

Get-VMHost -Location $cluster |Get-ScsiLun -LunType "disk"

Get-VMHost -Location $cluster |Get-ScsiLun -LunType "disk"|where {$_.MultipathPolicy -ne "RoundRobin"}|Set-ScsiLun -MultipathPolicy RoundRobin

$AllHosts = Get-Cluster $cluster | Get-VMHost | where {($_.ConnectionState -like "Connected")}

foreach ($esxhost in $AllHosts) {Get-VMHost $esxhost | Get-ScsiLun -LunType disk | Where-Object {$_.Multipathpolicy -like "RoundRobin"} | Set-ScsiLun -CommandsToSwitchPath 1 | Select-Object CanonicalName, MultipathPolicy, CommandsToSwitchPath}

foreach ($esxhost in $AllHosts) {Get-VMHost $esxhost | Get-ScsiLun -LunType disk | Where-Object {$_.Multipathpolicy -like "RoundRobin"} | Select-Object CanonicalName, MultipathPolicy, CommandsToSwitchPath}

