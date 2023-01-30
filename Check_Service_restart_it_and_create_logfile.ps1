param(
    $ServiceName
)

$ServiceName = $ServiceName
$LogDirectory = "Path"
$LogFile = Join-Path $LogDirectory "ServiceRestart.log"


if (!(Test-Path $LogDirectory)) {
  New-Item $LogDirectory -ItemType Directory
}

$Service = Get-Service -Name $ServiceName

if ($Service.Status -eq "Stopped") {
  if (Test-Path $LogFile) {
    $LastLine = Get-Content $LogFile | Select-Object -Last 1
    if ($LastLine.Contains($ServiceName)) {
      $Count = [int]$LastLine.Split(' ')[-1]
      $Count++
    } else {
      $Count = 0
    }
  }

  $Service | Start-Service
  $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  "$Timestamp The service '$ServiceName' was restarted. Count: $Count" | Out-File -Append $LogFile
}

Get-Content $LogFile | ForEach-Object {
  $LogDate = [datetime]::ParseExact($_.Split(' ')[0], "yyyy-MM-dd", $null)
  if ($LogDate -lt (Get-Date).AddDays(-7)) {
    $_ | Out-File $LogFile -Encoding UTF8 -Force -Append
  } else {
    $_
  }
}