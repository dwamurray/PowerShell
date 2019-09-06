Function New-Hash {                                                 
	param($algorithm,$path)
	$fileStream = [IO.File]::OpenRead((Resolve-Path $path))
	$hasher = [Security.Cryptography.HashAlgorithm]::Create($algorithm)
	$hash = $hasher.ComputeHash($filestream)
	$filestream.close()
	$filestream.dispose()
	return $hash
}
Function New-ChecksumFile {                                         
	param($path)
	$hash = New-Hash -algorithm sha256 -path $path
	$hashStr = [system.bitconverter]::tostring($hash).replace('-','')
	[IO.File]::WriteAllText("$($Path).checksum",$hashStr)
}

.\InstallPullServerConfig -DSCServiceSetup                        
.\SampleConfig.ps1                                               

Copy-Item -Path .\Dsc\PullDemo\MEMBER2.mof `                          
  -Destination c:\ProgramData\PSDSCPullServer\Configuration\e528dee8-6f0b-4885-98a1-1ee4d8e86d82.mof

Get-ChildItem -Path C:\ProgramData\PSDSCPullServer\Configuration -Filter *.mof |
ForEach-Object { New-ChecksumFile -path $_.FullName }

.\SampleSetPullMode.ps1                                         

Invoke-CimMethod -ComputerName MEMBER2 `                             
  -Namespace root/microsoft/windows/desiredstateconfiguration `
  -Class MSFT_DscLocalConfigurationManager `
  -MethodName PerformRequiredConfigurationChecks `
  -Arguments @{Flags = [uint32]1} -Verbose 



