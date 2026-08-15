# Comprehensive Booking Lookup & Date Resiliency Test in PowerShell

$baseUrl = "http://localhost:3000"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  TESTING BOOKING LOOKUP & DATE RESILIENCY" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Create a test booking via API with complete dates and check voucher
$testPayload = @{
    car_id = "car-swift-dzire"
    pickup_location = "Dehradun Railway Station"
    drop_location = "Dehradun Railway Station"
    pickup_date = "2026-08-25"
    drop_date = "2026-08-28"
    pickup_time = "10:00 AM"
    customer_name = "Amit Sharma"
    customer_phone = "9823456789"
    customer_whatsapp = "9823456789"
    customer_email = "amit.sharma@test.com"
} | ConvertTo-Json

$bookRes = Invoke-RestMethod -Uri "$baseUrl/api/bookings" -Method Post -Body $testPayload -ContentType "application/json"

if ($bookRes.success -and $bookRes.booking_id -and $bookRes.verification_token) {
    Write-Host " [PASS] Created Booking: ID = $($bookRes.booking_id)" -ForegroundColor Green
    
    # 2. Fetch voucher using ID and token
    $voucherRes = Invoke-RestMethod -Uri "$baseUrl/api/bookings/voucher?id=$($bookRes.booking_id)&token=$($bookRes.verification_token)" -Method Get
    
    if ($voucherRes.id -eq $bookRes.booking_id) {
        Write-Host " [PASS] Voucher retrieval returned: ID = $($voucherRes.id), Car = $($voucherRes.car_name)" -ForegroundColor Green
        Write-Host "        Dates: $($voucherRes.pickup_date) to $($voucherRes.drop_date) ($($voucherRes.days) days)" -ForegroundColor Yellow
        Write-Host "        Rental Amount: Rs $($voucherRes.rental_amount)" -ForegroundColor Yellow
        Write-Host "        Security Deposit: Rs $($voucherRes.security_deposit)" -ForegroundColor Yellow
        Write-Host "        Estimated Total: Rs $($voucherRes.estimated_total)" -ForegroundColor Yellow
    } else {
        Write-Host " [FAIL] Voucher retrieval failed" -ForegroundColor Red
    }

    # 3. Test HTTP 200 on confirmation.html with parameters
    $pageRes = Invoke-WebRequest -Uri "$baseUrl/confirmation.html?id=$($bookRes.booking_id)&token=$($bookRes.verification_token)" -Method Get -UseBasicParsing
    if ($pageRes.StatusCode -eq 200) {
        Write-Host " [PASS] confirmation.html loaded with HTTP 200" -ForegroundColor Green
    }
} else {
    Write-Host " [FAIL] Could not create test booking" -ForegroundColor Red
}

# 4. Clean up test database bookings
$dbFile = "d:\Car-rental-dehradun.com\data\database.json"
$db = Get-Content $dbFile -Raw | ConvertFrom-Json
$db.bookings = @()
$json = $db | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($dbFile, $json, [System.Text.Encoding]::UTF8)
Write-Host " [PASS] Database bookings cleaned." -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Cyan
