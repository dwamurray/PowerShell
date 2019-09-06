﻿Workflow Get-ARPCache {

$data = InlineScript {
  $results = arp -a | where {$_ -match 'dynamic'}
  [regex]$rxip="(\d{1,3}\.){3}\d{1,3}"
  [regex]$rxmac="(\w{2}-){5}\w{2}"
  foreach ($line in $results) {
    [pscustomobject][ordered]@{
    IP=$rxip.Match($line).Value
    MAC=$rxmac.Match($line).Value
    }
  } #foreach
 } #inlinescript

$data | Sort-Object -Property IP
} #workflow
