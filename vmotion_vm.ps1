Connect-VIServer -Server "vcenter"

$vms = Import-CSV C:\scripts\vms.csv
 
foreach ($vm in $vms){
      Get-VM $vm.name | Move-VM -Datastore $vm.targetDatastore
}
