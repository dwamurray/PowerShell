function Get-Info {
    param([string]$computername='localhost')
    $os = Get-WmiObject -class Win32_OperatingSystem -comp $computername
    $cs = Get-WmiObject -class Win32_ComputerSystem -comp $computername
    $props = @{'ComputerName'=$os.csname;
               'OSVersion'=$os.version;
               'SPVersion'=$os.servicepackmajorversion;
               'Model'=$cs.model;
               'Mfgr'=$cs.manufacturer}
    $obj = New-Object -TypeName PSObject -Property $props
    $obj.PSObject.TypeNames.Insert(0,'Custom.Info')
    Write-Output $obj
}

Get-Info | Format-Table
Get-Info | Format-List
Get-Info | Format-Wide
