function Do-This {
    Write-Host "Inside the function" -foreground Green
    Write-Host "Variable contains '$variable'" -foreground Green
    $variable = 'Function'
    Write-Host "Variable now contains '$variable'" -foreground Green
    Gw -Class Win32_BIOS
}

Write-Host "Inside the script" -foreground Red
$variable = "Script"
Write-Host "Variable now contains '$variable'" -foreground Red

New-Alias -Name gw -Value Get-WmiObject -Force
Gw -Class Win32_ComputerSystem

Do-This

Write-Host "Back in the script" -foreground Red
Write-Host "Variable contains '$variable'" -foreground Red
Write-Host "Done with the script" -foreground Red
