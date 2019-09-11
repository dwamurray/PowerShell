function get-info {

BEGIN {
del c:\results.csv -ea silentlycontinue
del c:\errors.txt -ea silentlycontinue
}

PROCESS {

$servers = get-content c:\servers.txt

foreach ( $server in $servers ) 
{

$net = if (reg query \\$server"\hklm\software\microsoft\net framework setup\ndp\v3.5" 2>> c:\errors.txt) {echo Yes
} elseif (
$lastexitcode -eq "0"
) {echo No
} else {
$_ | out-file c:\errors.txt -append
}

$reg = try {
reg.exe query \\$server\hklm\software\rbs /v "SSPInstalled"2>> c:\errors.txt | 
select-string ".\..\..*"
} catch {
echo "Server = $server, Error = $_" | 
out-file c:\errors.txt -append
}

$disk = try {
get-wmiobject win32_logicaldisk -computer $server -ea stop | 
where { $_.deviceid -eq "C:" }
} catch {
echo "Server = $server, Error = $_" | 
out-file c:\errors.txt -append
}

$os = try {
Get-WmiObject Win32_OperatingSystem -computer $server -ea stop
} catch {
echo "Server = $server, Error = $_" | 
out-file c:\errors.txt -append
}

$version = try {
get-wmiobject win32_computersystem -computername $server -ea stop 
} catch {
echo "Server = $server, Error = $_" | 
out-file c:\errors.txt -append
}

$obj = new-object -typename psobject

$obj | add-member -membertype noteproperty `
-name Server -value $os.csname

$obj | add-member -membertype noteproperty `
-name OS -value $os.caption

$obj | add-member -membertype noteproperty `
-name Version -value $version.systemtype

$obj | add-member -membertype noteproperty `
-name SPInstalled -value $os.csdversion

$obj | add-member -membertype noteproperty `
-name 'Patch level' -value ($reg.matches | select -expand value)

$obj | add-member -membertype noteproperty `
-name '.NET 3.5' -value $net

$obj | add-member -membertype noteproperty `
-name FreeSpaceMB -value ($disk.freespace / 1MB -as [int])

Write-output $obj

}
}
}
get-info | export-csv c:\results.csv -notype
