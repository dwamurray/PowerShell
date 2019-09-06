Function Get-NBTName {

$data=nbtstat /n | Select-String "<" | where {$_ -notmatch "__MSBROWSE__"}

#trim each line
$lines=$data | foreach { $_.Line.Trim()}

#split each line at the space into an array and add
#each element to a hash table
$lines | foreach { 
 $temp=$_ -split "\s+"

 #create an object from the hash table
 [PSCustomObject]@{
 Name=$temp[0]
 NbtCode=$temp[1]
 Type=$temp[2]
 Status=$temp[3]
 }
 
}

} #end function
