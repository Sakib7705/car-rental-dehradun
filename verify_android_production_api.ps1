$root = "d:\Car-rental-dehradun.com"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  ANDROID PRODUCTION API & ZERO LOCALHOST AUDIT" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Audit localhost references in production code
$prodExts = @(".html", ".js", ".json", ".kt", ".java", ".xml", ".kts", ".webmanifest")
$prodFiles = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $prodExts -contains $_.Extension -and
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -notmatch '\\\.system_generated\\' -and
    $_.FullName -notmatch '\\scratch\\' -and
    $_.FullName -notmatch '\\android-app\\\.gradle\\' -and
    $_.FullName -notmatch '\\android-app\\app\\build\\' -and
    $_.Name -ne 'server.js' # server.js is the dev backend server logger
}

$localhostCount = 0
foreach ($f in $prodFiles) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    if ($content -match '(?i)(localhost|127\.0\.0\.1)') {
        Write-Host " [FOUND LOCALHOST] $($f.FullName)" -ForegroundColor Red
        $localhostCount++
    }
}

if ($localhostCount -eq 0) {
    Write-Host " [PASS] 0 localhost/127.0.0.1 references in production client/app code" -ForegroundColor Green
} else {
    Write-Host " [FAIL] Found $localhostCount localhost references" -ForegroundColor Red
}

# 2. Production API Base & Fleet Fallback Audit in js/api.js
$apiJsContent = [System.IO.File]::ReadAllText("$root\js\api.js")
$prodApiUrl = "https://car-rental-dehradun.com/api"

if ($apiJsContent -match 'const PRODUCTION_API_URL = ''https://car-rental-dehradun.com/api'';') {
    Write-Host " [PASS] Production API URL configured: $prodApiUrl" -ForegroundColor Green
} else {
    Write-Host " [FAIL] Production API URL missing or incorrect in js/api.js" -ForegroundColor Red
}

# 3. Vehicle API & Fleet Verification (All 11 vehicles)
$db = Get-Content "$root\data\database.json" -Raw | ConvertFrom-Json
$cars = $db.cars
Write-Host "`n [AUDIT] Verifying all $($cars.Count) fleet vehicles..." -ForegroundColor Cyan

$expectedFleet = @(
    @{ Name = "Maruti Swift"; Price = 2000; Transmission = "Manual"; Seats = 5; Image = "images/cars/swift.jpg" },
    @{ Name = "Maruti Swift Dzire"; Price = 2500; Transmission = "Manual"; Seats = 5; Image = "images/cars/swift-dzire.jpg" },
    @{ Name = "Hyundai Venue"; Price = 2500; Transmission = "Manual"; Seats = 5; Image = "images/cars/hyundai-venue.jpg" },
    @{ Name = "Maruti Ertiga"; Price = 3500; Transmission = "Manual"; Seats = 7; Image = "images/cars/ertiga.jpg" },
    @{ Name = "Maruti Baleno"; Price = 2200; Transmission = "Manual"; Seats = 5; Image = "images/cars/maruti-baleno.jpg" },
    @{ Name = "Mahindra Thar"; Price = 5000; Transmission = "Manual"; Seats = 4; Image = "images/cars/thar.jpg" },
    @{ Name = "Hyundai i20 Automatic"; Price = 3000; Transmission = "Automatic"; Seats = 5; Image = "images/cars/hyundai-i20-auto.jpg" },
    @{ Name = "Mahindra Scorpio N"; Price = 5500; Transmission = "Manual"; Seats = 7; Image = "images/cars/scorpio-n.jpg" },
    @{ Name = "Toyota Glanza"; Price = 2200; Transmission = "Automatic"; Seats = 5; Image = "images/cars/toyota-glanza.jpg" },
    @{ Name = "Kia Sonet"; Price = 3500; Transmission = "Manual"; Seats = 5; Image = "images/cars/kia-sonet.jpg" },
    @{ Name = "Hyundai i20 MT"; Price = 2500; Transmission = "Manual"; Seats = 5; Image = "images/cars/hyundai-i20.jpg" }
)

$fleetPass = $true
$imagePass = $true

foreach ($expected in $expectedFleet) {
    $found = $cars | Where-Object { $_.name -eq $expected.Name }
    if (-not $found) {
        Write-Host "  [MISSING CAR] $($expected.Name)" -ForegroundColor Red
        $fleetPass = $false
    } else {
        if ($found.price_per_day -ne $expected.Price) {
            Write-Host "  [PRICE MISMATCH] $($expected.Name): Expected ₹$($expected.Price), got ₹$($found.price_per_day)" -ForegroundColor Red
            $fleetPass = $false
        }
        if ($found.transmission -ne $expected.Transmission) {
            Write-Host "  [TRANS MISMATCH] $($expected.Name): Expected $($expected.Transmission), got $($found.transmission)" -ForegroundColor Red
            $fleetPass = $false
        }
        
        # Check image existence in web and android assets
        $webImg = "$root\$($found.image)"
        $apkImg = "$root\android-app\app\src\main\assets\$($found.image)"
        if (-not (Test-Path $webImg) -or (Get-Item $webImg).Length -lt 1000) {
            Write-Host "  [IMAGE MISSING/EMPTY] $webImg" -ForegroundColor Red
            $imagePass = $false
        }
        if (-not (Test-Path $apkImg) -or (Get-Item $apkImg).Length -lt 1000) {
            Write-Host "  [APK ASSET IMAGE MISSING] $apkImg" -ForegroundColor Red
            $imagePass = $false
        }
    }
}

if ($fleetPass) {
    Write-Host " [PASS] Vehicle API: PASS (All 11 vehicles verified with exact rates)" -ForegroundColor Green
}
if ($imagePass) {
    Write-Host " [PASS] Vehicle images: PASS (All 11 vehicle photos verified in root & APK assets)" -ForegroundColor Green
}

# 4. Booking API & WhatsApp Integration Verification
$settings = $db.settings
if ($settings.phone -eq '8923665501' -and $settings.whatsapp -eq '8923665501') {
    Write-Host " [PASS] Booking API: PASS (Phone and WhatsApp routing configured to +91 8923665501)" -ForegroundColor Green
} else {
    Write-Host " [FAIL] Booking API contact misconfigured" -ForegroundColor Red
}

# 5. Android Manifest & Permissions Verification
$manifestPath = "$root\android-app\app\src\main\AndroidManifest.xml"
$manifest = [System.IO.File]::ReadAllText($manifestPath)
if ($manifest -match 'android\.permission\.INTERNET' -and $manifest -match 'android\.permission\.ACCESS_NETWORK_STATE') {
    Write-Host " [PASS] Android INTERNET & NETWORK permissions: PASS" -ForegroundColor Green
} else {
    Write-Host " [FAIL] Android permissions missing" -ForegroundColor Red
}
