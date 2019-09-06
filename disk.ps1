Param(                      #A
	[string]$computerName, #A
	[int]$driveType = 3    #A
)
Get-WmiObject –Class Win32_LogicalDisk –Filter "drivetype=$driveType"  #B
[CA ]         –ComputerName $computerName |   #C
Select-Object –Property DeviceID,
@{Name='ComputerName'; Expression={$_.__SERVER}}, Size, FreeSpace
