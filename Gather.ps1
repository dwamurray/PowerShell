# Check for elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
    Write-Warning "Aborting script..."
    Break
}

cls
if (Test-Path -Path "C:\MININT") {Write-Host "C:\MININT exists, deleting...";Remove-Item C:\MININT -Recurse}
cscript.exe ZTIGather.wsf /debug:true
# C:\Tools\CMTrace C:\MININT\SMSOSD\OSDLOGS\ZTIGather.log
