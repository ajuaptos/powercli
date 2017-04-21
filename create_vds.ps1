#Create VDS Script 
#This script creates a VDS switch with current portgroups for LAN and SAN
Connect-VIServer -Server vcenter
  
# Create VDS
$vds_name = "VDS Name"
Write-Host "`nCreating new VDS" $vds_name
$vds = New-VDSwitch -Name $vds_name -version "6.0" -Location (Get-Datacenter -Name "Datacenter")
 
# Create DVPortgroups
Write-Host "Creating new backbone-vlan10"
New-VDPortgroup -Name "backbone-vlan10" -Vds $vds -NumPorts "64" -vlanid 10 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "backbone-vlan10" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new backbone-vlan8"
New-VDPortgroup -Name "backbone-vlan8" -Vds $vds -NumPorts "64" -vlanid 8 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "backbone-vlan8" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Management Network"
New-VDPortgroup -Name "Management Network" -Vds $vds -NumPorts "64" -vlanid 8 | Set-VDPortgroup -PortBinding Ephemeral
Get-VDPortgroup "Management Network" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new iscsi1-vlan196"
New-VDPortgroup -Name "iscsi1-vlan196" -Vds $vds -NumPorts "128" -vlanid 196 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "iscsi1-vlan196" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink2", "uplink3", "uplink4"

Write-Host "Creating new iscsi2-vlan196"
New-VDPortgroup -Name "iscsi2-vlan196" -Vds $vds -NumPorts "128" -vlanid 196 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "iscsi2-vlan196" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink3", "uplink4"

Write-Host "Creating new iscsi-vlan184"
New-VDPortgroup -Name "iscsi-vlan184" -Vds $vds -NumPorts "128" -vlanid 184 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "iscsi-vlan184" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink2", "uplink3", "uplink4"

Write-Host "Creating new iscsi-vlan186"
New-VDPortgroup -Name "iscsi-vlan186" -Vds $vds -NumPorts "128" -vlanid 186 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "iscsi-vlan186" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink3", "uplink4"

Write-Host "Creating new heartbeat-vlan199"
New-VDPortgroup -Name "heartbeat-vlan199" -Vds $vds -NumPorts "16" -vlanid 199 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "heartbeat-vlan199" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new QST-PWAPP-vlan15"
New-VDPortgroup -Name "QST-PWAPP-vlan15" -Vds $vds -NumPorts "16" -vlanid 15 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "QST-PWAPP-vlan15" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Orion-vlan16"
New-VDPortgroup -Name "Orion-vlan16" -Vds $vds -NumPorts "16" -vlanid 16 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Orion-vlan16" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new ADFS-vlan19"
New-VDPortgroup -Name "ADFS-vlan19" -Vds $vds -NumPorts "16" -vlanid 19 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "ADFS-vlan19" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Exch-vlan20"
New-VDPortgroup -Name "Exch-vlan20" -Vds $vds -NumPorts "16" -vlanid 20 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Exch-vlan20" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Lync-Int-vlan22"
New-VDPortgroup -Name "Lync-Int-vlan22" -Vds $vds -NumPorts "16" -vlanid 22 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Lync-Int-vlan22" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Exch-MX-vlan23"
New-VDPortgroup -Name "Exch-MX-vlan23" -Vds $vds -NumPorts "16" -vlanid 23 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Exch-MX-vlan23" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new WST-Web-vlan31"
New-VDPortgroup -Name "WST-Web-vlan31" -Vds $vds -NumPorts "16" -vlanid 31 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "WST-Web-vlan31" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Share-PTAPP-vlan32"
New-VDPortgroup -Name "Share-PTAPP-vlan32" -Vds $vds -NumPorts "16" -vlanid 32 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Share-PTAPP-vlan32" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Share-PTDB-vlan33"
New-VDPortgroup -Name "Share-PTDB-vlan33" -Vds $vds -NumPorts "16" -vlanid 33 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Share-PTDB-vlan33" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Hosts-vlan50"
New-VDPortgroup -Name "Hosts-vlan50" -Vds $vds -NumPorts "16" -vlanid  50 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Hosts-vlan50" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new CTS-CasperInt-vlan55"
New-VDPortgroup -Name "CTS-CasperInt-vlan55" -Vds $vds -NumPorts "16" -vlanid 55 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "CTS-CasperInt-vlan55" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Corp-WebDB-vlan100"
New-VDPortgroup -Name "Corp-WebDB-vlan100" -Vds $vds -NumPorts "16" -vlanid 100 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Corp-WebDB-vlan100" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new AX-DB-vlan122"
New-VDPortgroup -Name "AX-DB-vlan122" -Vds $vds -NumPorts "16" -vlanid 122 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "AX-DB-vlan122" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new BCP-SQL-vlan123"
New-VDPortgroup -Name "BCP-SQL-vlan123" -Vds $vds -NumPorts "16" -vlanid 123 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "BCP-SQL-vlan123" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new QTS-CIFS-vlan128"
New-VDPortgroup -Name "QTS-CIFS-vlan128" -Vds $vds -NumPorts "16" -vlanid 128 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "QTS-CIFS-vlan128" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Citrixapp-vlan132"
New-VDPortgroup -Name "Citrixapp-vlan132" -Vds $vds -NumPorts "16" -vlanid 132 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Citrixapp-vlan132" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new UP-CitrixTS-vlan133"
New-VDPortgroup -Name "UP-CitrixTS-vlan133" -Vds $vds -NumPorts "16" -vlanid 133 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "UP-CitrixTS-vlan133" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new NFS-vlan194"
New-VDPortgroup -Name "NFS-vlan194" -Vds $vds -NumPorts "128" -vlanid 194 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "NFS-vlan194" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink3", "uplink4"

Write-Host "Creating new CIFS-vlan198"
New-VDPortgroup -Name "CIFS-vlan198" -Vds $vds -NumPorts "128" -vlanid 198 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "CIFS-vlan198" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Cisco_NMS-vlan207"
New-VDPortgroup -Name "Cisco_NMS-vlan207" -Vds $vds -NumPorts "16" -vlanid 207 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Cisco_NMS-vlan207" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new SCOM-SCCM-vlan256"
New-VDPortgroup -Name "SCOM-SCCM-vlan256" -Vds $vds -NumPorts "16" -vlanid 256 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "SCOM-SCCM-vlan256" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new SCOM-SQL-vlan257"
New-VDPortgroup -Name "SCOM-SQL-vlan257" -Vds $vds -NumPorts "16" -vlanid 257 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "SCOM-SQL-vlan257" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new SSL-VPN-vlan300"
New-VDPortgroup -Name "SSL-VPN-vlan300" -Vds $vds -NumPorts "16" -vlanid 300 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "SSL-VPN-vlan300" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new DMZ-vlan301"
New-VDPortgroup -Name "DMZ-vlan301" -Vds $vds -NumPorts "64" -vlanid 301 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "DMZ-vlan301" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new QST-PW-WB-vlan315"
New-VDPortgroup -Name "QST-PW-WB-vlan315" -Vds $vds -NumPorts "16" -vlanid 315 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "QST-PW-WB-vlan315" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new ADFS-PS-vlan319"
New-VDPortgroup -Name "ADFS-PS-vlan319" -Vds $vds -NumPorts "16" -vlanid 319 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "ADFS-PS-vlan319" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Lync-Out-vlan321"
New-VDPortgroup -Name "Lync-Out-vlan321" -Vds $vds -NumPorts "16" -vlanid 321 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Lync-Out-vlan321" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Lync-DMZ-vlan322"
New-VDPortgroup -Name "Lync-DMZ-vlan322" -Vds $vds -NumPorts "16" -vlanid 322 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Lync-DMZ-vlan322" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Brightmail-vlan323"
New-VDPortgroup -Name "Brightmail-vlan323" -Vds $vds -NumPorts "16" -vlanid 323 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Brightmail-vlan323" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Share-PTWB-vlan332"
New-VDPortgroup -Name "SharePTWB-vlan332" -Vds $vds -NumPorts "32" -vlanid 332 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "SharePTWB-vlan332" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new CTS-CasperEx-vlan355"
New-VDPortgroup -Name "CTS-CasperEx-vlan355" -Vds $vds -NumPorts "16" -vlanid 355 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "CTS-CasperEx-vlan355" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new Corp-Web-vlan400"
New-VDPortgroup -Name "Corp-Web-vlan400" -Vds $vds -NumPorts "32" -vlanid 400 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "Corp-Web-vlan400" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new AX-AP-vlan422"
New-VDPortgroup -Name "AX-AP-vlan422" -Vds $vds -NumPorts "16" -vlanid 422 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "AX-AP-vlan422" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new CitrixSGW-vlan432"
New-VDPortgroup -Name "CitrixSGW-vlan432" -Vds $vds -NumPorts "16" -vlanid 432 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "CitrixSGW-vlan432" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"

Write-Host "Creating new RODC-vlan453"
New-VDPortgroup -Name "RODC-vlan453" -Vds $vds -NumPorts "16" -vlanid 453 | Set-VDPortgroup -PortBinding Static | out-null
Get-VDPortgroup "RODC-vlan453" | Get-VDUplinkTeamingPolicy | Set-VDUplinkTeamingPolicy -UnusedUplinkPort "uplink1", "uplink2"
