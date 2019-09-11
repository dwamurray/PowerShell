function Get-ServerInfo {
param (
$computername = 'localhost'
)

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

Get-ServerInfo 2008member | Format-Table -auto

# Can also output using:
# Get-ServerInfo -comp 2008member | Export-CSV info.csv
# Get-ServerInfo -comp 2008member | ConvertTo-HTML | Out-File info.html
