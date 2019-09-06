param(
    [string]$computerName
)
$status = Test-Connection -ComputerName $computername -count 1
if ($status.statuscode -eq 0) {
    Write-Output $True
} else {
    Write-Output $False
}
