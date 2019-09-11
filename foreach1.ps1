$servers = get-content .\desktop\servers.txt
foreach ( $server in $servers )
{ get-wmiobject win32_service -computer $server | 
select name,caption,startmode,startname |
format-table @{l='Service Name';e='name'},
@{l='Description';e='caption'},
@{l='Start Type';e='startmode'},
@{l='Runas account';e='startname'} -auto |
out-file "c:\documents and settings\murrayd\desktop\$server.txt" }
