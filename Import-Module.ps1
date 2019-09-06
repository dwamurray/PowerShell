$module="FileSystem"
 Import-Module $module
 
 Get-Command -Module $module -CommandType Function | 
 ForEach -begin { $commands=""} -Process {
   $commands+="Function $($_.Name) { $($_.Definition) } ;" 
 } -end { $commands+="Export-ModuleMember -function *" }
 
 #create a dynamic module on the remote machine 
 invoke-command {
 Param ($commandText) 
 $sb=[scriptblock]::Create($commandText)
 $mod=New-Module -scriptblock $sb
 $mod | import-module
 } -session $sess -argumentList $commands 
