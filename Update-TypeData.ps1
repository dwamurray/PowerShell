param([string]$computername)

Update-TypeData -AppendPath C:\OurTypes.ps1xml -EA SilentlyContinue

$bios = Get-WmiObject -class Win32_BIOS -ComputerName $computername
$cs = Get-WmiObject -class Win32_ComputerSystem -ComputerName $computername
$properties = @{ComputerName=$computername
                Manufacturer=$cs.manufacturer
                Model=$cs.model
                BIOSSerial=$bios.serialnumber}
$obj = New-Object -TypeName PSObject -Property $properties
$obj.PSObject.TypeNames.Insert(0,"OurTypes.Computer")
Write-Output $obj
