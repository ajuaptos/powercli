#Script Variables
$sESXiHost = 'host'
$sCommunity = 'admincommunity'
$sTarget = 'SNMPtarget'
$sPort = '161'

#Connect to ESXi host
Connect-VIServer -Server $sESXiHost

#Clear SNMP Settings
Get-VMHostSnmp | Set-VMHostSnmp -ReadonlyCommunity @()

#Add SNMP Settings
Get-VMHostSnmp | Set-VMHostSnmp -Enabled:$true -AddTarget -TargetCommunity $sCommunity -TargetHost $sTarget -TargetPort $sPort -ReadOnlyCommunity $sCommunity

#Get SNMP Settings
$Cmd= Get-EsxCli -VMHost $sESXiHost
$Cmd.System.Snmp.Get()
