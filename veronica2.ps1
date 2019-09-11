function get-info {

BEGIN {
del errors.txt -ea silentlycontinue
      }

PROCESS {

$server = $_

try { 
get-wmiobject win32_service -computer $server -ea stop | 
select name,caption,startmode,startname |
format-table @{l='Service Name';e='name'},
@{l='Description';e='caption'},
@{l='Start Type';e='startmode'},
@{l='Runas account';e='startname'} -auto |
out-file "$server-services.txt" 
    }
    
catch {
write-output "Cannot obtain services information from $server, Error = $_" | 
out-file errors.txt -append
      } 

try {
get-wmiobject win32_dcomapplicationsetting -computer $server -ea stop |
select appid,description,runasuser |
format-table -auto |
out-file "$server-dcom.txt" 
    }

catch {
write-output "Cannot obtain DCOM information from $server, Error = $_" | 
out-file errors.txt -append
      }
       }

END {
write-host "Complete"
    }

		            }
				  
get-content servers.txt | get-info
