Param ([string]$computername=$env:computername)

New-Variable -name ADS_UF_DONT_EXPIRE_PASSWD -value 0x10000 -Option Constant

[ADSI]$server="WinNT://$computername"
$users=$server.children | where {$_.schemaclassname -eq "user"}

foreach ($user in $users) {
  if ($user.userflags.value -band $ADS_UF_DONT_EXPIRE_PASSWD) { #A
      $pwdNeverExpires=$True
  }
  else {
      $pwdNeverExpires=$False
  }
  New-Object -TypeName PSObject -Property @{
   Computername=$server.name.value
   Username=$User.name.value
   PasswordNeverExpires=$pwdNeverExpires
  }
}
