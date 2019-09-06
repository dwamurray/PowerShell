$data = @()
$fso = New-Object -ComObject "Scripting.FileSystemObject"
$top = $fso.GetFolder("c:\test")
$data += New-Object PSObject -Property @{
 Path = $top.Path
 Size = $top.Size
}
foreach ($sf in $top.SubFolders) {
 $data += New-Object PSObject -Property @{
  Path = $sf.Path
  Size = $sf.Size
 }
} 
$data 
