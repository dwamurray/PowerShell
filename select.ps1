$os = Get-WmiObject -class Win32_OperatingSystem -comp localhost
$cs = Get-WmiObject -class Win32_ComputerSystem -comp localhost
$bios = Get-WmiObject -class Win32_BIOS -comp localhost
$proc = Get-WmiObject -class Win32_Processor -comp localhost | 
Select -first 1
