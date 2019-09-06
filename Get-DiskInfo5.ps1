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
    foreach ($computer in $computername) {
      $params = @{computername=$computer
                  filter="drivetype='fixed'"
                  class='win32_logicaldisk'}
      $disks = Get-WmiObject @params

      foreach ($disk in $disks) {
        $danger = $True
        if ($disk.freespace / $disk.capacity * 100 -le $threshold) {
          $danger = $False
        }
        $props = @{ComputerName=$computer
                   Size=$disk.capacity / 1GB -as [int]
                   Free = $disk.freespace / 1GB -as [int]
                   Danger=$danger}
        $obj = New-Object –TypeName PSObject –Property $props
        Write-Output $obj
      }
    }
  }
  END {}
}
