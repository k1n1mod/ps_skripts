$LogDirectory = "Path\Logs"
$LogFile = Join-Path $LogDirectory "ServiceRestart.log"

$RestartEntries = Get-Content $LogFile | Select-Object -Last 5

foreach ($RestartEntry in $RestartEntries) {
  $Timestamp = $RestartEntry.Split(' ')[0]
  $ServiceName = $RestartEntry.Split(' ')[4]
  $Count = $RestartEntry.Split(' ')[-1]

  if ($Count -gt 4) {
    $warning = "The service '$ServiceName' has been restarted $Count times. Last restart was on $Timestamp"
    Ninja-Property-Set servicealert ($warning) 
  } else {
    $warning = ""
    Ninja-Property-Set servicealert ($warning)
  }
}