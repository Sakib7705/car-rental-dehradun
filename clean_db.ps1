$dbFile = "d:\Car-rental-dehradun.com\data\database.json"
$db = Get-Content $dbFile -Raw | ConvertFrom-Json
$db.bookings = @()
$json = $db | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($dbFile, $json, [System.Text.Encoding]::UTF8)
Write-Host "Bookings reset to clean state (0 records)." -ForegroundColor Green
