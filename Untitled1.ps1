#Create and populating *-Applications.csv file for server
$LMkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall","SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$LMtype = [Microsoft.Win32.RegistryHive]::LocalMachine
$LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMtype,$server)
ForEach (
$Key in $LMkeys
) {
$RegKey = $LMRegKey.OpenSubkey($key)
ForEach (
$subName in $RegKey.getsubkeynames()
) {
foreach ( 
$sub in $RegKey.opensubkey($subName)
) {
$MasterKeys += (New-Object PSObject -Property @{
"ComputerName" = $server
"Name" = $sub.getvalue("displayname")
"SystemComponent" = $sub.getvalue("systemcomponent")
"ParentKeyName" = $sub.getvalue("parentkeyname")
"Version" = $sub.getvalue("DisplayVersion")
"UninstallCommand" = $sub.getvalue("UninstallString")
} )
}
}
}
$("Name, Version")  | Out-File $($folder + $server + "\" +  $server + "-Applications.csv") -Append -Encoding ascii
$MasterKeys = ($MasterKeys | Where {$_.Name -ne $Null -AND $_.SystemComponent -ne "1" -AND $_.ParentKeyName -eq $Null} | 
select Name,Version,ComputerName,UninstallCommand | 
sort Name)
foreach (
$key in $masterkeys
) {
$($key.Name + "," + $key.Version)  | 
Out-File $($folder + $server + "\" +  $server + "-Applications.csv") -Append
}