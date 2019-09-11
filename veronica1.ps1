$servers = get-content servers.txt

foreach ( $server in $servers ) 
{
try {
get-wmiobject win32_service -computer $server -ea stop | 
select name,caption,startmode,startname |
convertto-html |
out-file "$server.html" 
     }
catch {
write-output "Server name = $server, Error = $_" | out-file errors.txt -append
      }
}
