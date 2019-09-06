Function Where-LowDiskSpace {
  Param(
    [int]$FreeSpace
  )
  BEGIN {}
  PROCESS {
    If ((100 * ($_.FreeSpace / $_.Size) -lt $FreeSpace)) {
      Write-Output $_
    }
  }
  END {}
}
