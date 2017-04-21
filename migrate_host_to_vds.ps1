#Script that migrates 2 LAN 2 SAN NICs from standard to VDS
# This script assumes: vmk0 as Management, vmk1 iscsi1, vmk2 iscsi2, vmk3 vlan184 and vmk4 iscsi186 vmk5 vmotion
# ESXi host to migrate from 

Connect-VIServer -Server vcenter

$vds_name = "vds_name"

$vmhost = "host"

# Add ESXi host to VDS and move SAN1

Get-VDSwitch -Name $vds_name | Add-VDSwitchVMHost -VMHost $vmhost -confirm:$false
Write-Host "Adding" $vmhost "SAN1 to" $vds_name
$vmhostNetworkAdapter = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic0
Get-VDSwitch -Name $vds_name | Add-VDSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $vmhostNetworkAdapter  -Confirm:$false

# Migrate VMkernel interfaces to VDS
  
# Iscsi1-vlan196#
$storage_portgroup = "iscsi1-vlan196"
Write-Host "Migrating" $storage_portgroup "to" $vds_name
$dvportgroup = Get-VDPortgroup -name $storage_portgroup -VDSwitch $vds_name
$vmk = Get-VMHostNetworkAdapter -Name vmk1 -VMHost $vmhost
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false | Out-Null
 
# iscsi-vlan184#
$vmotion_portgroup = "iscsi-vlan184"
Write-Host "Migrating" $vmotion_portgroup "to" $vds_name
$dvportgroup = Get-VDPortgroup -name $vmotion_portgroup -VDSwitch $vds_name
$vmk = Get-VMHostNetworkAdapter -Name vmk3 -VMHost $vmhost
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false | Out-Null

#Move Interface SAN2
Write-Host "Adding" $vmhost "SAN2 to" $vds_name
$vmhostNetworkAdapter = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic1
Get-VDSwitch -Name $vds_name | Add-VDSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $vmhostNetworkAdapter  -Confirm:$false

# Iscsi2-vlan196#
$storage_portgroup = "iscsi2-vlan196"
Write-Host "Migrating" $storage_portgroup "to" $vds_name
$dvportgroup = Get-VDPortgroup -name $storage_portgroup -VDSwitch $vds_name
$vmk = Get-VMHostNetworkAdapter -Name vmk2 -VMHost $vmhost
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false | Out-Null
 
# iscsi-vlan186#
$vmotion_portgroup = "iscsi-vlan186"
Write-Host "Migrating" $vmotion_portgroup "to" $vds_name
$dvportgroup = Get-VDPortgroup -name $vmotion_portgroup -VDSwitch $vds_name
$vmk = Get-VMHostNetworkAdapter -Name vmk4 -VMHost $vmhost
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false | Out-Null

# vmotion#
$vmotion_portgroup = "vmotion"
Write-Host "Migrating" $vmotion_portgroup "to" $vds_name
$dvportgroup = Get-VDPortgroup -name $vmotion_portgroup -VDSwitch $vds_name
$vmk = Get-VMHostNetworkAdapter -Name vmk5 -VMHost $vmhost
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false | Out-Null

#Move Interface LAN1
Write-Host "Adding" $vmhost "LAN1 to" $vds_name
$vmhostNetworkAdapter = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic2
Get-VDSwitch -Name $vds_name | Add-VDSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $vmhostNetworkAdapter  -Confirm:$false

#loop through the guests assumes vSwitch0 is the LAN vSwitch
#Import-CSV C:\Users\fidelm\Documents\scripts\vm-ip-at3esxi17.csv | ForEach-Object {
#$vmname= $_.vmname
#$vss = $_.vss
#$vds = $_.vds
#$virtualSwitch = "vSwitch0"

#Get-VMHost $vmhost |
#Get-VirtualSwitch -Name $virtualSwitch |
#Get-VirtualPortGroup -Name $vss |
#Get-VM | Get-NetworkAdapter | Set-NetworkAdapter -Portgroup $vds -Confirm:$false

#}

# Management #
$mgmt_portgroup = "Management Network"
Write-Host "Migrating" $mgmt_portgroup "to" $vds_name
$dvportgroup = Get-VDPortgroup -name $mgmt_portgroup -VDSwitch $vds_name
$vmk = Get-VMHostNetworkAdapter -Name vmk0 -VMHost $vmhost
Set-VMHostNetworkAdapter -PortGroup $dvportgroup -VirtualNic $vmk -confirm:$false | Out-Null

#Move Interface LAN2
Write-Host "Adding" $vmhost "LAN2 to" $vds_name
$vmhostNetworkAdapter = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic3
Get-VDSwitch -Name $vds_name | Add-VDSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $vmhostNetworkAdapter  -Confirm:$false


# Remove old vSwitch portgroups assumes there are only two vSwitches: vSwitch0 and vSwitch1
$vswitch = Get-VirtualSwitch -VMHost $vmhost -Name vSwitch0
Remove-VirtualSwitch -VirtualSwitch $vswitch

$vswitch1 = Get-VirtualSwitch -VMHost $vmhost -Name vSwitch1
Remove-VirtualSwitch -VirtualSwitch $vswitch1

 
disconnect-VIServer -Server $global:DefaultVIServers -Force -Confirm:$false
