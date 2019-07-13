$groups=([ADSI]"WinNT://localhost,computer").psbase.children | 
where { $_.psbase.schemaClassName -eq 'group' } | 
foreach { ($_.name)[0]}
$("Group, Members") | out-host

foreach (
$Group in $groups
) {
$Group | out-File $($folder + $server + "\" +  $server + "-Groups.csv") -Append -Encoding ascii
$members=$([ADSI]"WinNT://$Server/$Group,group").psbase.Invoke('Members') | foreach { $_.GetType().InvokeMember('ADspath', 'GetProperty', $null, $_, $null).Replace('WinNT://', '') }
if (
$members -is [system.array]
) {
foreach (
$member in $members
) {
$("," + $member) | out-File $($folder + $server + "\" +  $server + "-Groups.csv") -Append
}
}
else {
$("," + $member) | out-File $($folder + $server + "\" +  $server + "-Groups.csv") -Append
}
}