[cmdletbinding()]

Param (
[Parameter(Position=0,HelpMessage="Enter a computername")]
[string]$computername=$env:COMPUTERNAME,
[Parameter(Position=1)]
[object]$Credential
)

if ($credential -AND ($computername -eq $env:Computername)) {
  Write-Warning "You can't use credentials for the local computer"
  Break
}

$command="Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computername"

if ($credential -is [System.Management.Automation.PSCredential]) {
  Write-Verbose "Using a passed PSCredential object"
  $Cred=$credential
}
elseif ($credential -is [string]) {
    Write-Verbose "Getting credentials for $credential"
    $Cred=Get-Credential -Credential $credential
}

if ($cred) {
    Write-Verbose "Appending credential to command"
   $command+=" -Credential `$cred"
}
else {
    Write-Verbose "Executing without credentials"
}

#invoke the command expression
Write-Verbose "Running the WMI command"
Invoke-Expression $command
