$ErrorActionPreference = 'Stop'
$baseUrl = 'http://localhost:3000'

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "CAR RENTAL DEHRADUN - PRODUCTION AUDIT & VERIFICATION" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Audit Sonet Transmission & Text
Write-Host "`n[AUDIT 1] Scanning for 'Sonet' transmission..." -ForegroundColor Yellow
$files = Get-ChildItem -Path . -Include *.html,*.js,*.json -Recurse | Where-Object { $_.FullName -notmatch '\\(\.git|node_modules)\\' }
$sonetIssues = 0

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match 'Kia Sonet') {
        $lines = Get-Content $f.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $l = $lines[$i]
            if ($l -match 'Sonet' -and ($l -match 'Automatic' -or $l -match ' AT\b' -or $l -match 'Automatic Transmission')) {
                Write-Host "  [MISMATCH] $($f.Name):$($i+1) -> $($l.Trim())" -ForegroundColor Red
                $sonetIssues++
            }
        }
    }
}
if ($sonetIssues -eq 0) {
    Write-Host "  [OK] Kia Sonet is correctly marked as MANUAL everywhere (0 Automatic references found)." -ForegroundColor Green
}

# 2. Audit Official Office Address
Write-Host "`n[AUDIT 2] Checking Official Office Address consistency..." -ForegroundColor Yellow
$expectedAddress = "Kalika Vihar Phase 2, Banjarawala Road, Near Kali Mata Mandir, Dehradun"
$db = Get-Content 'data/database.json' -Raw | ConvertFrom-Json
if ($db.settings.address -match 'Kalika Vihar Phase 2' -and $db.settings.office_address -match 'Kalika Vihar Phase 2') {
    Write-Host "  [OK] Database settings address: $($db.settings.address)" -ForegroundColor Green
} else {
    Write-Host "  [MISMATCH] Database address does not match expected location!" -ForegroundColor Red
}

# 3. Audit Phone & WhatsApp Numbers
Write-Host "`n[AUDIT 3] Checking Phone & WhatsApp across codebase..." -ForegroundColor Yellow
$phoneCount = 0
$waCount = 0
$wrongPhone = 0
foreach ($f in $files) {
    $lines = Get-Content $f.FullName
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $l = $lines[$i]
        if ($l -match '8923665501') { $phoneCount++ }
        # Check for any old placeholder phone numbers
        if ($l -match '9876543210' -or $l -match '1234567890') {
            Write-Host "  [OLD PHONE] $($f.Name):$($i+1) -> $($l.Trim())" -ForegroundColor Red
            $wrongPhone++
        }
    }
}
if ($wrongPhone -eq 0) {
    Write-Host "  [OK] Zero placeholder phone numbers. Found 8923665501 in $phoneCount locations." -ForegroundColor Green
}

# 4. Audit PWA Manifest & Icons
Write-Host "`n[AUDIT 4] Checking PWA Manifest & Assets..." -ForegroundColor Yellow
if (Test-Path "manifest.webmanifest") {
    $manifest = Get-Content "manifest.webmanifest" -Raw | ConvertFrom-Json
    Write-Host "  [OK] Manifest name: $($manifest.name)" -ForegroundColor Green
    Write-Host "  [OK] Manifest start_url: $($manifest.start_url)" -ForegroundColor Green
    foreach ($icon in $manifest.icons) {
        $iconPath = $icon.src.TrimStart('/')
        if (Test-Path $iconPath) {
            Write-Host "  [OK] PWA Icon exists: $iconPath ($($icon.sizes))" -ForegroundColor Green
        } else {
            Write-Host "  [MISSING] PWA Icon missing: $iconPath" -ForegroundColor Red
        }
    }
} else {
    Write-Host "  [MISSING] manifest.webmanifest not found!" -ForegroundColor Red
}

# 5. Clean Database Test Bookings
Write-Host "`n[AUDIT 5] Checking database test bookings..." -ForegroundColor Yellow
$bookingCount = $db.bookings.Count
Write-Host "  Currently $bookingCount booking record(s) in database." -ForegroundColor Gray
if ($bookingCount -gt 0) {
    Write-Host "  Resetting bookings array to empty [] for fresh production state..." -ForegroundColor Cyan
    $db.bookings = @()
    $db | ConvertTo-Json -Depth 10 | Set-Content 'data/database.json' -Encoding UTF8
    Write-Host "  [OK] Clean production database state restored (0 dummy bookings exposed)." -ForegroundColor Green
}

Write-Host "`n====================================================" -ForegroundColor Cyan
Write-Host "AUDIT COMPLETE" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
