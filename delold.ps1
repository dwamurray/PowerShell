$limit = (Get-Date).AddDays(-15)
$path = "C:\Some\Path"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | 
Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | 
Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | 
Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | 
Where-Object { !$_.PSIsContainer }) -eq $null } | 
Remove-Item -Force -Recurse

# Note you could change this so that it removes files not modified in last 15 days etc - investigate
