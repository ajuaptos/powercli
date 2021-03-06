# Adds the base cmdlets
Add-PSSnapin VMware.VimAutomation.Core
# This script adds some helper functions and sets the appearance.
. "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"

#Connect to VMWare vCenter
Connect-VIServer -Server vcenter

#Connect to VMWare Host
$ESXHost = Get-Datacenter cluster | Get-VMHost
foreach ($Server in $ESXHost)
{
    $myesxcli = get-esxcli -VMHost $Server
    foreach ($Host1 in $myesxcli)
    {

    #Set RDM drives as perennially reserved
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303538", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303539", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303541", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303542", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303543", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303630", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303634", $true)
	$myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303635", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303636", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303637", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303639", $true)
	$myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303638", $true)
    $myesxcli.storage.core.device.setconfig($false, "naa.60000970000197800445533030303633", $true)
	} 
}
