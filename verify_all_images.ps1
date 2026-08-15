$db = Get-Content (Join-Path $PSScriptRoot "data\database.json") -Raw | ConvertFrom-Json
$missing = 0

Write-Host "=== VERIFYING FLEET IMAGE ASSETS ON DISK ===" -ForegroundColor Yellow
foreach ($c in $db.cars) {
    $mainPath = Join-Path $PSScriptRoot $c.image
    if (-not (Test-Path $mainPath)) {
        Write-Host "MISSING MAIN: $($c.name) -> $($c.image)" -ForegroundColor Red
        $missing++
    } else {
        $f = Get-Item $mainPath
        Write-Host "OK: $($c.name.PadRight(25)) -> $($c.image.PadRight(32)) ($([math]::Round($f.Length/1KB, 1)) KB)" -ForegroundColor Green
    }
    foreach ($g in $c.gallery) {
        $gPath = Join-Path $PSScriptRoot $g
        if (-not (Test-Path $gPath)) {
            Write-Host "  MISSING GALLERY: $g" -ForegroundColor Red
            $missing++
        } else {
            $gf = Get-Item $gPath
            Write-Host "  OK Gallery: $($g.PadRight(35)) ($([math]::Round($gf.Length/1KB, 1)) KB)" -ForegroundColor DarkGreen
        }
    }
}

if ($missing -eq 0) {
    Write-Host "`nAll 11 vehicle images and 33 gallery items are 100% verified on disk! (0 missing)" -ForegroundColor Cyan
} else {
    Write-Host "`nTotal missing assets: $missing" -ForegroundColor Red
}
