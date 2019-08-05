Get-WmiObject  -namespace "root/MicrosoftIISv2"  -Class IIsWebServerSetting 
echo "Site, Virtual Directory" | Out-File "$folder\$server\$server-IIS.csv" -Append
foreach (
$site in $sites
) {
$iis=""
$sitename=""
$site.ServerComment | Out-File $($folder + $server + "\" +  $server + "-IIS.csv") -Append

Get-WmiObject -Authentication PacketPrivacy -Impersonation Impersonate -ComputerName $server -namespace "root/MicrosoftIISv2"`
-Query "SELECT * FROM IIsWebVirtualDirSetting" | 
where {$_.Name -match $site.name} | 
foreach {$($site.ServerComment + "," + $_.path)} | 
Out-File $($folder + $server + "\" +  $server + "-IIS.csv") -Append -Encoding ascii
}
