function GetServerInfoWork {

param([string]$computername)

$os = Get-WmiObject Win32_OperatingSystem -computer $computername

$disk = Get-WmiObject Win32_LogicalDisk -filter "DeviceID='C:'" `
-computer $computername

$obj = New-Object -TypeName PSObject

$obj | Add-Member -MemberType NoteProperty `
-Name ComputerName -Value $computername

$obj | Add-Member -MemberType NoteProperty `
-Name BuildNumber -Value ($os.BuildNumber)

$obj | Add-Member -MemberType NoteProperty `
-Name SPVersion -Value ($os.ServicePackMajorVersion)

$obj | Add-Member -MemberType NoteProperty `
-Name SysDriveFree -Value ($disk.free / 1MB -as [int])

Write-Output $obj
}

function Get-ServerInfo {

param (
[string[]]$computername
)

BEGIN {
$usedParameter = $False
if ($PSBoundParameters.ContainsKey('computername')) {
$usedParameter = $True
}

}
PROCESS {
if ($usedParameter) {
foreach ($computer in $computername) {
GetServerInfoWork -computername $computer
}

} else {
GetServerInfoWork -computername $_
}
}
END {}
}
