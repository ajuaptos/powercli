Connect-VIServer -Server vcenter

get-cluster "cluster" | 
Get-VM |
Get-HardDisk |
where {$_.StorageFormat -ne "LazyZeroedThick"} |
select Parent,StorageFormat,Filename |
Export-Csv C:\Users\fmichieli.CHEWY\Documents\scripts\PCI.csv -NoTypeInformation -UseCulture


