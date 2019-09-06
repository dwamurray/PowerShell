function Get-DiskInfo {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$True,
               ValueFromPipeline=$True,
               ValueFromPipelineByPropertyName=$True)]
    [string[]]$computerName,
    
    [Parameter(Mandatory=$True)]
    [ValidateRange(10,90)]
    [int]$threshold
  )
  BEGIN {}
  PROCESS {
    Write-Debug "Started PROCESS block"
    foreach ($computer in $computername) {
    
      Write-Debug "Computer name is $computer"
      $params = @{computername=$computer
                  filter="drivetype='3'"
                  class='win32_logicaldisk'}
      $disks = Get-WmiObject @params
      Write-Debug "Got the disks"
 
      foreach ($disk in $disks) {
        Write-Debug "Working on disk $($disk.deviceid)"
        Write-Debug "Size is $($disk.size)"
        Write-Debug "Free space is $($disk.freespace)"
        
        $danger = $False                                           #A
        if ($disk.freespace / $disk.size * 100 -le $threshold) {
          $danger = $True                                          #B
        }
        Write-Debug "Danger setting is $danger"
        
        $props = @{ComputerName=$computer
                   Size=$disk.size / 1GB -as [int]
                   Free = $disk.freespace / 1GB -as [int]
                   Danger=$danger}
        Write-Debug "Created hashtable will create object next"
        
        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj
      }
    }
  }
  END {}
}

