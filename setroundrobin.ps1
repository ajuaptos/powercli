Connect-VIServer -Server vcenter -User user

Get-VMHost -Location Temp-ENT|Get-ScsiLun -LunType "disk"

Get-VMHost -Location Temp-ENT|Get-ScsiLun -LunType "disk"|where {$_.MultipathPolicy -ne "RoundRobin"}|Set-ScsiLun -MultipathPolicy RoundRobin
