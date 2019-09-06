Get-WmiObject -Class Win32_logicaldisk |
where {$_.DriveType -eq 3} |
foreach {$($_.DeviceID + "," + ($_.FreeSpace/ 1MB -as [int]) + "MB," + ($_.Size/ 1MB -as [int])`
+ "MB," + $(($_.Size/ 1MB -as [int]) - ($_.FreeSpace/ 1MB -as [int])) + "MB," +  $_.VolumeName)}
