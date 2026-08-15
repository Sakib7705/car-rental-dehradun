# Comprehensive Automated QA & SEO Verification Suite for Car Rental Dehradun Platform

param([int]$Port = 3000)

$baseUrl = "http://localhost:$Port"
Write-Host "Starting Full QA & SEO Test Suite on $baseUrl..." -ForegroundColor Cyan

$passCount = 0
$failCount = 0

function Assert-Test ($name, $condition, $details = "") {
    if ($condition) {
        Write-Host "  [PASS] $name" -ForegroundColor Green
        $global:passCount++
    } else {
        Write-Host "  [FAIL] $name - $details" -ForegroundColor Red
        $global:failCount++
    }
}

# 1. Test Core Public Pages
$corePages = @(
    "", "cars.html", "car-details.html", "book.html", "about.html", 
    "contact.html", "terms.html", "privacy.html", "cancellation.html", 
    "faq.html", "admin/login.html", "admin/index.html", "admin/cars.html", 
    "admin/bookings.html", "admin/settings.html", "manifest.webmanifest", 
    "sw.js", "sitemap.xml", "robots.txt"
)

Write-Host "`n--- 1. Testing Core Pages & Assets ---" -ForegroundColor Yellow
foreach ($p in $corePages) {
    try {
        $res = Invoke-WebRequest -Uri "$baseUrl/$p" -UseBasicParsing -TimeoutSec 5
        Assert-Test "Core route: /$p" ($res.StatusCode -eq 200) "Status: $($res.StatusCode)"
    } catch {
        Assert-Test "Core route: /$p" $false $_.Exception.Message
    }
}

# 2. Test All 23 Location Pages
$locationPages = @(
    "locations/index.html",
    "locations/dehradun.html", "locations/mussoorie.html", "locations/rishikesh.html",
    "locations/haridwar.html", "locations/nainital.html", "locations/haldwani.html",
    "locations/jim-corbett.html", "locations/auli.html", "locations/dhanaulti.html",
    "locations/chakrata.html", "locations/lansdowne.html", "locations/tehri.html",
    "locations/ranikhet.html", "locations/almora.html", "locations/roorkee.html",
    "locations/rudrapur.html", "locations/kashipur.html", "locations/kotdwar.html",
    "locations/uttarkashi.html", "locations/srinagar-garhwal.html", "locations/chamoli.html",
    "locations/bageshwar.html", "locations/pithoragarh.html"
)

Write-Host "`n--- 2. Testing All 23 Location SEO Pages ---" -ForegroundColor Yellow
foreach ($p in $locationPages) {
    try {
        $res = Invoke-WebRequest -Uri "$baseUrl/$p" -UseBasicParsing -TimeoutSec 5
        $hasSchema = if ($p -eq "locations/index.html") { $res.Content.Contains("BreadcrumbList") } else { $res.Content.Contains("AutoRental") -and $res.Content.Contains("FAQPage") }
        Assert-Test "Location route: /$p (HTTP 200 & Schema)" ($res.StatusCode -eq 200 -and $hasSchema) "Status: $($res.StatusCode)"
    } catch {
        Assert-Test "Location route: /$p" $false $_.Exception.Message
    }
}

# 3. Test All 13 Destination Guide Pages
$destPages = @(
    "destinations/index.html",
    "destinations/mussoorie.html", "destinations/rishikesh.html", "destinations/haridwar.html",
    "destinations/nainital.html", "destinations/jim-corbett.html", "destinations/auli.html",
    "destinations/char-dham.html", "destinations/dhanaulti.html", "destinations/chakrata.html",
    "destinations/lansdowne.html", "destinations/tehri.html", "destinations/almora.html",
    "destinations/ranikhet.html"
)

Write-Host "`n--- 3. Testing All 13 Destination Guides ---" -ForegroundColor Yellow
foreach ($p in $destPages) {
    try {
        $res = Invoke-WebRequest -Uri "$baseUrl/$p" -UseBasicParsing -TimeoutSec 5
        $hasBreadcrumbs = $res.Content.Contains("BreadcrumbList")
        Assert-Test "Destination guide: /$p (HTTP 200 & Schema)" ($res.StatusCode -eq 200 -and $hasBreadcrumbs) "Status: $($res.StatusCode)"
    } catch {
        Assert-Test "Destination guide: /$p" $false $_.Exception.Message
    }
}

# 4. Test All 11 Travel Guide Articles
$guidePages = @(
    "travel-guides/index.html",
    "travel-guides/best-cars-uttarakhand-road-trip.html",
    "travel-guides/self-drive-car-rental-uttarakhand-guide.html",
    "travel-guides/dehradun-to-mussoorie-road-trip.html",
    "travel-guides/dehradun-to-rishikesh-road-trip.html",
    "travel-guides/dehradun-to-haridwar-road-trip.html",
    "travel-guides/best-7-seater-cars-uttarakhand.html",
    "travel-guides/suv-vs-sedan-uttarakhand-roads.html",
    "travel-guides/char-dham-car-rental-guide.html",
    "travel-guides/nainital-road-trip-guide.html",
    "travel-guides/jim-corbett-road-trip-guide.html",
    "travel-guides/things-to-check-before-renting-self-drive.html"
)

Write-Host "`n--- 4. Testing All 11 Travel Guide Articles ---" -ForegroundColor Yellow
foreach ($p in $guidePages) {
    try {
        $res = Invoke-WebRequest -Uri "$baseUrl/$p" -UseBasicParsing -TimeoutSec 5
        Assert-Test "Travel article: /$p (HTTP 200)" ($res.StatusCode -eq 200) "Status: $($res.StatusCode)"
    } catch {
        Assert-Test "Travel article: /$p" $false $_.Exception.Message
    }
}

# 5. Test Public APIs & 10 Vehicle Exact Prices
Write-Host "`n--- 5. Testing Public APIs & Exact Rates for All 10 Vehicles ---" -ForegroundColor Yellow
try {
    $settings = Invoke-RestMethod -Uri "$baseUrl/api/settings" -Method GET
    Assert-Test "GET /api/settings (Phone: 8923665501, KM: 200)" ($settings.phone -eq "8923665501" -and $settings.default_km_limit -eq 200) "Locations count: $($settings.locations.Count)"
} catch {
    Assert-Test "GET /api/settings" $false $_.Exception.Message
}

$cars = $null
try {
    $cars = Invoke-RestMethod -Uri "$baseUrl/api/cars" -Method GET
    Assert-Test "GET /api/cars (All 10 catalogue vehicles)" ($cars.Count -ge 10) "Found: $($cars.Count) cars"
} catch {
    Assert-Test "GET /api/cars" $false $_.Exception.Message
}

$expectedPrices = @{
    "car-swift"        = 2000
    "car-swift-dzire"  = 2500
    "car-ertiga"       = 3500
    "car-scorpio-n"    = 5500
    "car-thar"         = 5000
    "car-sonet"        = 3500
    "car-venue"        = 2500
    "car-baleno"       = 2200
    "car-glanza"       = 2200
    "car-i20-manual"   = 2500
    "car-i20-auto"     = 3000
}

foreach ($carId in $expectedPrices.Keys) {
    $expectedPrice = $expectedPrices[$carId]
    $foundCar = $cars | Where-Object { $_.id -eq $carId } | Select-Object -First 1
    if ($foundCar) {
        Assert-Test "Price Match for $($foundCar.name) (₹$expectedPrice/day)" ($foundCar.price_per_day -eq $expectedPrice) "Got: ₹$($foundCar.price_per_day)"
        
        # Verify car image URL returns HTTP 200 and has valid non-zero content
        try {
            $imgRes = Invoke-WebRequest -Uri "$baseUrl/$($foundCar.image)" -UseBasicParsing -TimeoutSec 5
            Assert-Test "Image Asset for $($foundCar.name) ($($foundCar.image))" ($imgRes.StatusCode -eq 200 -and $imgRes.RawContentLength -gt 1000) "Size: $([math]::Round($imgRes.RawContentLength/1024, 1)) KB"
        } catch {
            Assert-Test "Image Asset for $($foundCar.name) ($($foundCar.image))" $false $_.Exception.Message
        }
    } else {
        Assert-Test "Car ID $carId found in catalogue" $false "Missing vehicle"
    }
}

# Test Swift Details Route
try {
    $swiftRes = Invoke-WebRequest -Uri "$baseUrl/car-details.html?id=car-swift" -UseBasicParsing -TimeoutSec 5
    Assert-Test "Car details route: /car-details.html?id=car-swift" ($swiftRes.StatusCode -eq 200) "Status: $($swiftRes.StatusCode)"
} catch {
    Assert-Test "Car details route: /car-details.html?id=car-swift" $false $_.Exception.Message
}

# 6. Test Booking Flow & Overlap Collision Detection
Write-Host "`n--- 6. Testing Booking Flow & Collision Prevention ---" -ForegroundColor Yellow
$randomDay = (Get-Random -Minimum 10 -Maximum 20)
$pDate = "2026-11-$randomDay"
$dDate = "2026-11-" + ($randomDay + 3)

$bookingPayload = @{
    car_id = "car-scorpio-n"
    pickup_location = "Dehradun Office - Kalika Vihar Phase 2, Banjarawala Road, Near Kali Mata Mandir"
    drop_location = "Dehradun Office - Kalika Vihar Phase 2, Banjarawala Road, Near Kali Mata Mandir"
    pickup_date = $pDate
    drop_date = $dDate # 4 days @ 5500 = 22000
    customer_name = "Vikram Aditya"
    customer_phone = "9822334455"
    customer_whatsapp = "9822334455"
    customer_email = "vikram@example.com"
    special_requests = "Trip to Auli Skiing"
} | ConvertTo-Json

$createdBooking = $null
try {
    $createdBooking = Invoke-RestMethod -Uri "$baseUrl/api/bookings" -Method POST -Body $bookingPayload -ContentType "application/json"
    Assert-Test "Submit 4-Day Scorpio N Booking" ($createdBooking.success -eq $true -and $createdBooking.rental_amount -eq 22000) "Amount: ₹$($createdBooking.rental_amount)"
    Assert-Test "WhatsApp URL contains correct total & phone" ($createdBooking.whatsapp_url.Contains("22000") -and $createdBooking.whatsapp_url.Contains("8923665501")) "URL check"
} catch {
    Assert-Test "Submit 4-Day Scorpio N Booking" $false $_.Exception.Message
}

# Conflict Check (attempt exact same dates on the newly booked car)
$conflictPayload = @{
    car_id = "car-scorpio-n"
    pickup_location = "Dehradun Office - Kalika Vihar Phase 2, Banjarawala Road, Near Kali Mata Mandir"
    drop_location = "Dehradun Office - Kalika Vihar Phase 2, Banjarawala Road, Near Kali Mata Mandir"
    pickup_date = $pDate
    drop_date = $dDate
    customer_name = "Duplicate Request"
    customer_phone = "9899887766"
} | ConvertTo-Json

try {
    $res = Invoke-WebRequest -Uri "$baseUrl/api/bookings" -Method POST -Body $conflictPayload -ContentType "application/json" -UseBasicParsing
    Assert-Test "Overlapping booking rejected (HTTP 409)" ($false) "Should have failed"
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Assert-Test "Overlapping booking rejected (HTTP 409 Conflict)" ($statusCode -eq 409) "Status: $statusCode"
}

# 7. Test Admin Auth
Write-Host "`n--- 7. Testing Admin Authentication ---" -ForegroundColor Yellow
$loginPayload = @{ username = "admin"; password = "admin123" } | ConvertTo-Json
try {
    $loginRes = Invoke-RestMethod -Uri "$baseUrl/api/admin/login" -Method POST -Body $loginPayload -ContentType "application/json"
    Assert-Test "Admin login successful" ($loginRes.success -eq $true -and $loginRes.token -ne $null) "Token received"
    if ($loginRes.token) {
        $adminBookings = Invoke-RestMethod -Uri "$baseUrl/api/admin/bookings" -Method GET -Headers @{ Authorization = "Bearer $($loginRes.token)" }
        $adminBookingsArr = @($adminBookings)
        Assert-Test "Admin bookings endpoint protected & accessible" ($adminBookingsArr.Count -ge 1) "Count: $($adminBookingsArr.Count)"
    }
} catch {
    Assert-Test "Admin login test" $false $_.Exception.Message
}

Write-Host "`n====================================================" -ForegroundColor Cyan
Write-Host "QA & SEO TEST RESULTS: $passCount PASSED, $failCount FAILED" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Red" })
Write-Host "====================================================" -ForegroundColor Cyan

if ($failCount -gt 0) { exit 1 } else { exit 0 }
