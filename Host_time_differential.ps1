# For verifying time difference between hosts to be below 5 seconds after Daylight savings will show which hosts are withing allowed difference and which hosts are not this can be exported to csv with a | export


cls
Connect-VIServer -Server Vcenter1

$allowedDifferenceSeconds = 5

get-view -ViewType HostSystem -Property Name, ConfigManager.DateTimeSystem | %{    
    #get host datetime system
    $dts = get-view $_.ConfigManager.DateTimeSystem
    
    #get host time
    $t = $dts.QueryDateTime()
    
    #calculate time difference in seconds
    $s = ( $t - [DateTime]::UtcNow).TotalSeconds
    
    #check if time difference is too much
    if([math]::abs($s) -gt $allowedDifferenceSeconds){
        #print host and time difference in seconds
        $row = "" | select HostName, Seconds
        $row.HostName = $_.Name
        $row.Seconds = $s
        $row
    }
    else{
        Write-Host "Time on" $_.Name "within allowed range"
    }
}
