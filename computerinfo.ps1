param ($computername)
Write-Host '------- COMPUTER INFORMATION -------'
Write-Host "Computer Name: $computername"

$os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername
Write-Host "   OS Version: $($os.version)"
Write-Host "     OS Build: $($os.buildnumber)"
Write-Host " Service Pack: $($os.servicepackmajorversion)"

$cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername
Write-Host "          RAM: $($cs.totalphysicalmemory)"
Write-Host " Manufacturer: $($cs.manufacturer)"
Write-Host "        Model: $($cd.model)"
Write-Host "   Processors: $($cs.numberofprocessors)"

$bios = Get-WmiObject -Class Win32_BIOS -ComputerName $computername
Write-Host "BIOS Serial: $($bios.serialnumber)"

Write-Host ''
Write-Host '------- DISK INFORMATION -------'
Get-WmiObject -Class Win32_LogicalDisk -Comp $computername -Filt 'drivetype=3' |
Select-Object @{n='Drive';e={$_.DeviceID}},
              @{n='Size(GB)';e={$_.Size / 1GB -as [int]}},
              @{n='FreeSpace(GB)';e={$_.freespace / 1GB -as [int]}} |
Format-Table -AutoSize
