$Location = "C:\"
Clear-Host
Get-Content c:\users\david\desktop\list.txt | Foreach-Object {New-Item -path $Location -name $_ -itemType "directory"}
