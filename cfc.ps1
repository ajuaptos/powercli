add-pssnapin VMware.VimAutomation.Core

Connect-VIServer -Server "vcenter" -

$SorterVMName1 = "SORTER-PC_bk"
$SorterVMName2 = "SORTER-PC_bk1"
$SorterVMName = "SORTER-PC"
$BellVMName1 = "CFC1BEL1523D_bk"
$BellVMName2 = "CFC1BEL1523D_bk1"
$BellVMName = "CFC1BEL1523D"
$esxName1 = "cfc1esx01.chewy.local"
$Datastore1 ="CFC1-PV0019-G01E-L010-ESX_Servers-GVW"
$esxName2 = "cfc1esx02.chewy.local"
$Datastore2 ="CFC1ESX02_Local"

Get-VM -Name $SorterVMName1 | Remove-VM -DeletePermanently -Confirm:$false
New-VM -Name $SorterVMName1 -VM $SorterVMName -VMHost $esxName1 -Datastore $Datastore1
Get-VM -Name $SorterVMName2 | Remove-VM -DeletePermanently -Confirm:$false
New-VM -Name $SorterVMName2 -VM $SorterVMName1 -VMHost $esxName2 -Datastore $Datastore2
Get-VM -Name $BellVMName1 | Remove-VM -DeletePermanently -Confirm:$false
New-VM -Name $BellVMName1 -VM $BellVMName -VMHost $esxName1 -Datastore $Datastore1
Get-VM -Name $BellVMName2 | Remove-VM -DeletePermanently -Confirm:$false
New-VM -Name $BellVMName2 -VM $BellVMName1 -VMHost $esxName2 -Datastore $Datastore2
 
foreach ($vm in $vms){
      Get-VM $vm.name | Move-VM -Datastore $vm.targetDatastore
}
