Connect-VIServer -Server vcenter



foreach ($esxi in (Get-VMHost | Sort Name)) {         
    $service = Get-VMHostService -VMHost $esxi | Where {$_.Key -eq "ntpd"}
    $policy = switch ($service.Policy) { 
                "off" { "Start and stop manually"} 
                "on" { "Start and stop with host" } 
                "automatic" { "Start automatically if any ports are open, and stop when all ports are closed" }
              }
    $ntp = Get-VMHostNtpServer -VMHost $esxi
    $esxi | Select-Object @{N="Cluster";E={$_.Parent}}, 
                          @{N="ESXi";E={$_.Name}}, 
                          @{N="NTP Server";E={$ntp}}, 
                          @{N="Service";E={$service.Label}}, 
                          @{N="Policy";E={$policy}},
                          @{N="Running";E={$service.Running}} | Export-Csv -Append -Path c:\Scripts\ntp-settings.csv
  } 