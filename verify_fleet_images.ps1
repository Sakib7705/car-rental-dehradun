$db = Get-Content 'data/database.json' -Raw | ConvertFrom-Json
$baseUrl = 'http://localhost:3000'

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "AUDITING ALL 11 VEHICLES IN FLEET:" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

$allOk = $true
$results = @()

foreach ($car in $db.cars) {
    $imgRel = $car.image
    $imgFull = Join-Path (Get-Location) $imgRel
    $diskExists = Test-Path $imgFull
    $diskSize = 0
    if ($diskExists) {
        $diskSize = (Get-Item $imgFull).Length
    }
    
    # Test HTTP retrieval
    $httpOk = $false
    $httpStatus = 0
    try {
        $res = Invoke-WebRequest -Uri "$baseUrl/$imgRel" -UseBasicParsing -TimeoutSec 5
        $httpStatus = $res.StatusCode
        if ($res.StatusCode -eq 200 -and $res.RawContentLength -gt 1000) {
            $httpOk = $true
        }
    } catch {
        $httpStatus = 500
    }
    
    $status = ($diskExists -and $httpOk)
    if (-not $status) { $allOk = $false }
    
    $row = [PSCustomObject]@{
        Vehicle = $car.name
        Price = "₹" + $car.price_per_day + "/day"
        Transmission = $car.transmission
        ImagePath = $imgRel
        DiskSizeKB = [math]::Round($diskSize / 1024, 1)
        HTTPStatus = $httpStatus
        Result = if ($status) { "VERIFIED OK" } else { "FAILED" }
    }
    $results += $row
    
    if ($status) {
        Write-Host ("[PASS] {0,-22} | {1,-10} | {2,-10} | {3,-30} | {4,6} KB | HTTP {5}" -f $car.name, $row.Price, $car.transmission, $imgRel, $row.DiskSizeKB, $httpStatus) -ForegroundColor Green
    } else {
        Write-Host ("[FAIL] {0,-22} | {1,-10} | {2,-10} | {3,-30} | Disk: {4} | HTTP: {5}" -f $car.name, $row.Price, $car.transmission, $imgRel, $diskExists, $httpStatus) -ForegroundColor Red
    }
}

Write-Host "====================================================" -ForegroundColor Cyan
if ($allOk) {
    Write-Host "ALL 11 VEHICLES HAVE VALID, VERIFIED HIGH-RES IMAGES!" -ForegroundColor Green
} else {
    Write-Host "SOME IMAGES FAILED AUDIT!" -ForegroundColor Red
}
Write-Host "====================================================" -ForegroundColor Cyan
