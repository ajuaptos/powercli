Connect-VIServer -Server vcenter

$key = "pref.timeLagInMilliseconds"
$value = "10"
 Get-vm -Name "fl*" | foreach { 
  $vm = Get-View $_.Id
  $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
  $vmConfigSpec.extraconfig += New-Object VMware.Vim.optionvalue
  $vmConfigSpec.extraconfig[0].Key=$key
  $vmConfigSpec.extraconfig[0].Value=$value
  $vm.ReconfigVM($vmConfigSpec)
}
