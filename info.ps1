$os = Get-WmiObject -class Win32_OperatingSystem -comp localhost
$cs = Get-WmiObject -class Win32_ComputerSystem -comp localhost
$bios = Get-WmiObject -class Win32_BIOS -comp localhost
$proc = Get-WmiObject -class Win32_Processor -comp localhost | 
Select -first 1

$props = @{'OSVersion'=$os.version;
           'Model'=$cs.model;
           'Manufacturer'=$cs.manufacturer;
           'BIOSSerial'=$bios.serialnumber;
           'ComputerName'=$os.__SERVER;
           'OSArchitecture'=$os.osarchitecture;
           'ProcArchitecture'=$proc.addresswidth}
$obj = New-Object -TypeName PSObject -Property $props
Write-Output $obj
