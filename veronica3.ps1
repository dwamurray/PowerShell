function get-servicepack {
 
BEGIN { del errors.txt -ea silentlycontinue }
 
PROCESS {
 
$server = $_
 
try {
get-wmiobject win32_operatingsystem -computername $server -ea stop |
select __SERVER,caption,servicepackmajorversion
}

catch {
write-output "Could not obtain information for $server, Error = $_" | out-file -append errors.txt
}
 
         }
                         }
            
get-content servers.txt | get-servicepack | export-csv servicepacks.csv -notypeinformation
