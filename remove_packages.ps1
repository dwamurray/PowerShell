$packages = get-content packages.txt

foreach (
$package in $packages
) {
Get-AppxPackage $package | 
Remove-AppxPackage -AllUsers
}
