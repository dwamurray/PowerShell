get-process | where { $_.name -like "*blackberry*" } | stop-process; 
get-process | where { $_.name -like "*rim*" } | stop-process