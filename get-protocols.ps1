function get-protocols {
 
BEGIN {

del protocols.txt -ea SilentlyContinue 

$testpath = test-path HKLM:\system\currentcontrolset\control\securityproviders\schannel\protocols\* 

if ( $testpath -eq $False ) {
write-output No security protocols configured on this server
}
       }

PROCESS {

$protocols = dir HKLM:\system\currentcontrolset\control\securityproviders\schannel\protocols | 
select -expand pschildname

foreach ( $protocol in $protocols )
 
{
$result = if ( test-path "HKLM:\system\currentcontrolset\control\securityproviders\schannel\protocols\$protocol\server" ) {
get-itemproperty -path "HKLM:\system\currentcontrolset\control\securityproviders\schannel\protocols\$protocol\server" |
select -expand enabled 
}
else {
'not configured' }
 
$value = if ( $result -eq "0" ) {
'Disabled'
}
elseif ( $result -eq "not configured" ) {
'not configured'
}
else { 
'Enabled' 
}
 
$obj = new-object -typename psobject
 
$obj | add-member -membertype noteproperty `
-name Protocol -value $protocol
 
$obj | add-member -membertype noteproperty `
-name value $value
 
Write-output $obj
}
    }
        }
 
get-protocols | ft -auto | out-file protocols.txt
