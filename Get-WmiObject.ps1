Get-WmiObject -class Win32_OperatingSystem -comp localhost |
Select __SERVER,Version,OSArchitecture

Get-WmiObject -class Win32_ComputerSystem -comp localhost |
Select Model,Manufacturer

Get-WmiObject -class Win32_BIOS -comp localhost |
Select SerialNumber

Get-WmiObject -class Win32_Processor -comp localhost | 
Select -first 1 -property AddressWidth
