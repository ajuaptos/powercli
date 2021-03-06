Connect-VIServer -Server "vcenter"
$VM = "vm"
     
        $Disks = Get-VM $VM | Get-HardDisk | Where-Object { $_.DiskType -eq 'RawPhysical' }

        ForEach( $Disk in $Disks ) {
          $DiskLun = Get-SCSILun $Disk.SCSICanonicalName -VMHost (Get-VM $VM).VMHost
          $DiskLunID = $DiskLun.RuntimeName.Substring($DiskLun.RuntimeName.LastIndexof('L') + 1)
            Write-Host "$DiskLunID, Capacity: $($Disk.CapacityGB) GB, Identifier: $($Disk.ScsiCanonicalName)"
          
            }
         
