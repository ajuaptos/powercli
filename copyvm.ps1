add-pssnapin VMware.VimAutomation.Core

Connect-VIServer -Server vcenter

$SorterVMName1 = "fll2alive01_bk"
$SorterVMName2 = "fll2alive01_bk1"
$SorterVMName = "fll2alive01"
$BellVMName1 = "fll2alive01_bk"
$BellVMName2 = "fll2alive01_bk1"
$BellVMName = "fll2alive01"
$esxName1 = "fll2aesx27.chewy.local"
$Datastore1 ="FLL2Pure21"
$esxName2 = "fll2aesx26.chewy.local"
$Datastore2 ="FLL2Pure23"

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
