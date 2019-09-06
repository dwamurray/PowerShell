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
    Write-Debug "Started PROCESS block"              #A
    foreach ($computer in $computername) {
    
      Write-Debug "Computer name is $computer"       #A
      $params = @{computername=$computer
                  filter="drivetype='3'"
                  class='win32_logicaldisk'}
      $disks = Get-WmiObject @params
      Write-Debug "Got the disks"                   #A
 
      foreach ($disk in $disks) {
        Write-Debug "Working on disk $($disk.deviceid)"     #A
        Write-Debug "Size is $($disk.size)"       #A
        Write-Debug "Free space is $($disk.freespace)"       #A
        
        $danger = $True
        if ($disk.freespace / $disk.size * 100 -le $threshold) {
          $danger = $False
        }
        Write-Debug "Danger setting is $danger"     #A
        
        $props = @{ComputerName=$computer
                   Size=$disk.size / 1GB -as [int]
                   Free = $disk.freespace / 1GB -as [int]
                   Danger=$danger}
        Write-Debug "Created hash table  will create object next"   #A
        
        $obj = New-Object –TypeName PSObject –Property $props
        Write-Output $obj
      }
    }
  }
  END {}
}
