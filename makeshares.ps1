$Location = "E:\"
Clear-Host

#create high-level folders
#Get-Content "c:\scripts\top_folders.txt" | Foreach-Object {New-Item -path $Location -name $_ -itemtype "directory"}

#import shares and invoke robocopy
Import-CSV "c:\scripts\shares.txt" | Foreach-Object {
$Source = $_.Source
$Destination = $_.Destination
robocopy.exe $Source $Destination /B /COPYALL /MIR /R:1 /W:1 /V /FP /NP /LOG+:c:\scripts\robocopy.txt /TEE
}

#Re run robocopy in list mode to generate compare
#Import-CSV "c:\scripts\shares.txt" | Foreach-Object {
#$Source = $_.Source
#$Destination = $_.Destination
#robocopy.exe $Source $Destination /L /B /COPYALL /MIR /R:5 /V /FP /NP /LOG+:c:\scripts\robocopy_Compare.txt /TEE
#}
