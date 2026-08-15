$prodBase = "https://car-rental-dehradun.com/api"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  TESTING LIVE PRODUCTION BACKEND (OVER INTERNET)" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Public settings
Write-Host "`n1. GET $prodBase/settings..." -ForegroundColor Yellow
try {
    $settings = Invoke-RestMethod -Uri "$prodBase/settings" -Method Get -TimeoutSec 10
    Write-Host "  [PASS] Business: $($settings.business_name), Phone: $($settings.phone)" -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Settings endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. Public cars
Write-Host "`n2. GET $prodBase/cars..." -ForegroundColor Yellow
try {
    $cars = Invoke-RestMethod -Uri "$prodBase/cars" -Method Get -TimeoutSec 10
    Write-Host "  [PASS] Loaded $($cars.Count) vehicles from live production backend" -ForegroundColor Green
    foreach ($c in $cars | Select-Object -First 3) {
        Write-Host "         $($c.name) - Rs $($c.price_per_day)/day ($($c.category))" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  [FAIL] Cars endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. Admin Login over HTTPS
Write-Host "`n3. POST $prodBase/admin/login..." -ForegroundColor Yellow
$loginPayload = @{
    username = "admin"
    password = "CarRentalAdmin@2026"
} | ConvertTo-Json

$token = $null
try {
    $loginRes = Invoke-RestMethod -Uri "$prodBase/admin/login" -Method Post -Body $loginPayload -ContentType "application/json" -TimeoutSec 10
    if ($loginRes.token) {
        $token = $loginRes.token
        Write-Host "  [PASS] Admin login successful! Token received." -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Admin login did not return a token: $($loginRes | ConvertTo-Json)" -ForegroundColor Red
    }
} catch {
    Write-Host "  [FAIL] Admin login failed: $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Authenticated Admin Bookings
if ($token) {
    Write-Host "`n4. GET $prodBase/admin/bookings (with Bearer token)..." -ForegroundColor Yellow
    try {
        $headers = @{ "Authorization" = "Bearer $token" }
        $adminBookings = Invoke-RestMethod -Uri "$prodBase/admin/bookings" -Method Get -Headers $headers -TimeoutSec 10
        Write-Host "  [PASS] Retrieved $($adminBookings.Count) bookings from production admin endpoint" -ForegroundColor Green
    } catch {
        Write-Host "  [FAIL] Admin bookings failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n====================================================" -ForegroundColor Cyan
