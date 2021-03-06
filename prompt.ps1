function prompt {
if ([System.IntPtr]::Size -eq 8) {$size = '64 bit'}    #1
else {$size = '32 bit'}

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$secprin = New-Object Security.Principal.WindowsPrincipal $currentUser #2

if ($secprin.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
{$admin = 'Administrator'}
else {$admin = 'non-Administrator'}                    #3

$host.ui.RawUI.WindowTitle = "$admin $size $(get-location)"   #4
"PS>  "
}
