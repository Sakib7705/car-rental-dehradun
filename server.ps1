# Car Rental Dehradun - Standalone PowerShell REST API & Static Web Server
# Zero external dependencies required. Runs natively on Windows with .NET HttpListener.

param(
    [int]$Port = 3000
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dbPath = Join-Path $scriptDir "data\database.json"

if (-not (Test-Path $dbPath)) {
    Write-Error "Database file not found at $dbPath"
    exit 1
}

function Load-DB {
    try {
        $json = [System.IO.File]::ReadAllText($dbPath, [System.Text.Encoding]::UTF8)
        return ($json | ConvertFrom-Json)
    } catch {
        Write-Error "Failed to load database: $_"
        return $null
    }
}

function Save-DB ($dbObj) {
    try {
        $json = $dbObj | ConvertTo-Json -Depth 20
        [System.IO.File]::WriteAllText($dbPath, $json, [System.Text.Encoding]::UTF8)
        return $true
    } catch {
        Write-Error "Failed to save database: $_"
        return $false
    }
}

function Get-Hash ($str, $salt) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($str + $salt)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $hashBytes = $sha.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hashBytes).Replace("-", "").ToLower()
}

function Send-JsonResponse ($response, $statusCode, $obj, [switch]$IsArray) {
    $response.StatusCode = $statusCode
    $response.ContentType = "application/json; charset=utf-8"
    $response.AddHeader("Access-Control-Allow-Origin", "*")
    $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    $response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
    $response.AddHeader("Cache-Control", "no-store, no-cache, must-revalidate, private")

    $json = $null
    if ($IsArray) {
        $arr = @($obj)
        if ($arr.Count -eq 0) {
            $json = "[]"
        } elseif ($arr.Count -eq 1) {
            $singleJson = $arr[0] | ConvertTo-Json -Depth 10
            $json = "[$singleJson]"
        } else {
            $json = $arr | ConvertTo-Json -Depth 10
        }
    } else {
        $json = $obj | ConvertTo-Json -Depth 10
    }

    $buffer = [System.Text.Encoding]::UTF8.GetBytes($json)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.OutputStream.Close()
}

function Send-FileResponse ($response, $filePath) {
    if (-not (Test-Path $filePath)) {
        # Check if alternative extension exists (e.g. .svg, .jpg, .png for .webp)
        $altExtensions = @(".svg", ".jpg", ".png", ".webp")
        $dir = [System.IO.Path]::GetDirectoryName($filePath)
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
        $foundAlt = $null
        foreach ($altExt in $altExtensions) {
            $candidate = Join-Path $dir ($baseName + $altExt)
            if (Test-Path $candidate) {
                $foundAlt = $candidate
                break
            }
        }
        if ($foundAlt) {
            $filePath = $foundAlt
        } else {
            $response.StatusCode = 404
            $msg = "<h1>404 Not Found</h1><p>The requested file was not found.</p>"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($msg)
            $response.ContentType = "text/html; charset=utf-8"
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.OutputStream.Close()
            return
        }
    }

    $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
    $mime = switch ($ext) {
        ".html" { "text/html; charset=utf-8" }
        ".css"  { "text/css; charset=utf-8" }
        ".js"   { "application/javascript; charset=utf-8" }
        ".json" { "application/json; charset=utf-8" }
        ".webmanifest" { "application/manifest+json; charset=utf-8" }
        ".png"  { "image/png" }
        ".jpg"  { "image/jpeg" }
        ".jpeg" { "image/jpeg" }
        ".webp" { "image/webp" }
        ".svg"  { "image/svg+xml" }
        ".ico"  { "image/x-icon" }
        ".xml"  { "application/xml; charset=utf-8" }
        ".txt"  { "text/plain; charset=utf-8" }
        default { "application/octet-stream" }
    }

    $response.StatusCode = 200
    $response.ContentType = $mime
    if ($ext -eq ".html" -or $filePath.Contains("admin")) {
        $response.AddHeader("Cache-Control", "no-cache, no-store, must-revalidate")
    } else {
        $response.AddHeader("Cache-Control", "public, max-age=86400")
    }

    $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
    $response.ContentLength64 = $fileBytes.Length
    $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
    $response.OutputStream.Close()
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    Write-Host "Could not start on port $Port, trying port 8080..."
    $Port = 8080
    $prefix = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    $listener.Start()
}

Write-Host "====================================================" -ForegroundColor Green
Write-Host "Car Rental Dehradun Server running at $prefix" -ForegroundColor Cyan
Write-Host "Database connected at $dbPath" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host "====================================================" -ForegroundColor Green

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $urlPath = $request.Url.AbsolutePath
    $httpMethod = $request.HttpMethod

    # Handle CORS preflight
    if ($httpMethod -eq "OPTIONS") {
        $response.StatusCode = 204
        $response.AddHeader("Access-Control-Allow-Origin", "*")
        $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        $response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
        $response.OutputStream.Close()
        continue
    }

    # API Endpoints
    if ($urlPath.StartsWith("/api/")) {
        $db = Load-DB
        if ($null -eq $db) {
            Send-JsonResponse $response 500 @{ error = "Database read error" }
            continue
        }

        # Read Request Body for POST / PUT
        $bodyJson = $null
        if ($request.HasEntityBody) {
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $bodyText = $reader.ReadToEnd()
            if (-not [string]::IsNullOrWhiteSpace($bodyText)) {
                try {
                    $bodyJson = $bodyText | ConvertFrom-Json
                } catch {}
            }
        }

        # --- GET /api/settings ---
        if ($urlPath -eq "/api/settings" -and $httpMethod -eq "GET") {
            $activeLocs = @($db.locations | Where-Object { $_.active -eq $true })
            $pub = @{
                business_name = $db.settings.business_name
                website = $db.settings.website
                phone = $db.settings.phone
                phone_display = $db.settings.phone_display
                whatsapp = $db.settings.whatsapp
                whatsapp_display = $db.settings.whatsapp_display
                email = $db.settings.email
                address = $db.settings.address
                default_km_limit = $db.settings.default_km_limit
                default_extra_km_charge = $db.settings.default_extra_km_charge
                default_security_deposit = $db.settings.default_security_deposit
                min_rental_days = $db.settings.min_rental_days
                seasonal_multiplier = $db.settings.seasonal_multiplier
                cancellation_window_hours = $db.settings.cancellation_window_hours
                documents_required = $db.settings.documents_required
                locations = $activeLocs
            }
            Send-JsonResponse $response 200 $pub
            continue
        }

        # --- GET /api/cars ---
        if ($urlPath -eq "/api/cars" -and $httpMethod -eq "GET") {
            $activeCars = @($db.cars | Where-Object { $_.active -eq $true })
            Send-JsonResponse $response 200 $activeCars -IsArray
            continue
        }

        # --- GET /api/cars/:id ---
        if ($urlPath.StartsWith("/api/cars/") -and $httpMethod -eq "GET") {
            $carId = $urlPath.Substring(10)
            $car = $db.cars | Where-Object { $_.id -eq $carId -and $_.active -eq $true } | Select-Object -First 1
            if ($null -eq $car) {
                Send-JsonResponse $response 404 @{ error = "Vehicle not found" }
            } else {
                Send-JsonResponse $response 200 $car
            }
            continue
        }

        # --- POST /api/bookings/check-availability ---
        if ($urlPath -eq "/api/bookings/check-availability" -and $httpMethod -eq "POST") {
            $carId = $bodyJson.car_id
            $pDate = $bodyJson.pickup_date
            $dDate = $bodyJson.drop_date

            if (-not $carId -or -not $pDate -or -not $dDate) {
                Send-JsonResponse $response 400 @{ error = "Missing car_id, pickup_date, or drop_date" }
                continue
            }

            $car = $db.cars | Where-Object { $_.id -eq $carId -and $_.active -eq $true } | Select-Object -First 1
            if ($null -eq $car) {
                Send-JsonResponse $response 404 @{ error = "Vehicle not found" }
                continue
            }

            $dt1 = [DateTime]::Parse($pDate)
            $dt2 = [DateTime]::Parse($dDate)
            $days = ($dt2 - $dt1).Days + 1
            if ($days -lt 1) {
                Send-JsonResponse $response 400 @{ error = "Drop date must be on or after pickup date" }
                continue
            }

            $minDays = if ($car.min_days) { $car.min_days } else { $db.settings.min_rental_days }
            if ($days -lt $minDays) {
                Send-JsonResponse $response 400 @{ error = "Minimum rental period is $minDays day(s)" }
                continue
            }

            # Check overlap
            $hasOverlap = $false
            foreach ($b in @($db.bookings)) {
                if ($b.car_id -eq $carId -and @("New", "Pending", "Confirmed") -contains $b.status) {
                    if (($pDate -le $b.drop_date) -and ($dDate -ge $b.pickup_date)) {
                        $hasOverlap = $true
                        break
                    }
                }
            }

            if ($hasOverlap) {
                Send-JsonResponse $response 200 @{
                    available = $false
                    message = "Vehicle is reserved for these dates. Please select other dates or cars."
                }
                continue
            }

            $dailyRate = [math]::Round($car.price_per_day * $db.settings.seasonal_multiplier)
            $rentalAmount = $dailyRate * $days
            $deposit = if ($car.security_deposit) { $car.security_deposit } else { $db.settings.default_security_deposit }
            $kmLimit = if ($car.daily_km_limit) { $car.daily_km_limit } else { $db.settings.default_km_limit }

            Send-JsonResponse $response 200 @{
                available = $true
                car_id = $car.id
                car_name = $car.name
                days = $days
                daily_rate = $dailyRate
                rental_amount = $rentalAmount
                security_deposit = $deposit
                km_limit_per_day = $kmLimit
                total_km_limit = $kmLimit * $days
                extra_km_charge = $car.extra_km_charge
                estimated_total = $rentalAmount + $deposit
            }
            continue
        }

        # --- POST /api/bookings ---
        if ($urlPath -eq "/api/bookings" -and $httpMethod -eq "POST") {
            $carId = $bodyJson.car_id
            $cName = [string]$bodyJson.customer_name
            $cPhone = [string]$bodyJson.customer_phone
            $pDate = [string]$bodyJson.pickup_date
            $dDate = [string]$bodyJson.drop_date

            if (-not $carId -or -not $cName -or -not $cPhone -or -not $pDate -or -not $dDate) {
                Send-JsonResponse $response 400 @{ error = "All mandatory fields must be filled" }
                continue
            }

            $car = $db.cars | Where-Object { $_.id -eq $carId -and $_.active -eq $true } | Select-Object -First 1
            if ($null -eq $car) {
                Send-JsonResponse $response 404 @{ error = "Vehicle not found" }
                continue
            }

            $dt1 = [DateTime]::Parse($pDate)
            $dt2 = [DateTime]::Parse($dDate)
            $days = ($dt2 - $dt1).Days + 1
            if ($days -lt 1) {
                Send-JsonResponse $response 400 @{ error = "Invalid dates" }
                continue
            }

            # Check overlap atomically
            $hasOverlap = $false
            foreach ($b in @($db.bookings)) {
                if ($b.car_id -eq $carId -and @("New", "Pending", "Confirmed") -contains $b.status) {
                    if (($pDate -le $b.drop_date) -and ($dDate -ge $b.pickup_date)) {
                        $hasOverlap = $true
                        break
                    }
                }
            }

            if ($hasOverlap) {
                Send-JsonResponse $response 409 @{ error = "Vehicle was just reserved by another customer for these dates." }
                continue
            }

            $dailyRate = [math]::Round($car.price_per_day * $db.settings.seasonal_multiplier)
            $rentalAmount = $dailyRate * $days
            $deposit = if ($car.security_deposit) { $car.security_deposit } else { $db.settings.default_security_deposit }
            $kmLimit = if ($car.daily_km_limit) { $car.daily_km_limit } else { $db.settings.default_km_limit }
            $totalEst = $rentalAmount + $deposit

            $bookingId = "CRD-" + (Get-Date -Format "yyyy") + "-" + (Get-Random -Minimum 1000 -Maximum 9999)
            $token = [System.Guid]::NewGuid().ToString("N")

            $newBooking = [PSCustomObject]@{
                id = $bookingId
                verification_token = $token
                car_id = $car.id
                car_name = $car.name
                car_image = $car.image
                pickup_location = [string]$bodyJson.pickup_location
                drop_location = [string]$bodyJson.drop_location
                pickup_date = $pDate
                drop_date = $dDate
                pickup_time = if ($bodyJson.pickup_time) { [string]$bodyJson.pickup_time } else { "10:00 AM" }
                days = $days
                daily_rate = $dailyRate
                rental_amount = $rentalAmount
                security_deposit = $deposit
                km_limit_per_day = $kmLimit
                total_km_limit = $kmLimit * $days
                extra_km_charge = $car.extra_km_charge
                estimated_total = $totalEst
                customer_name = $cName.Trim()
                customer_phone = $cPhone.Trim()
                customer_whatsapp = if ($bodyJson.customer_whatsapp) { [string]$bodyJson.customer_whatsapp } else { $cPhone.Trim() }
                customer_email = if ($bodyJson.customer_email) { [string]$bodyJson.customer_email } else { "" }
                special_requests = if ($bodyJson.special_requests) { [string]$bodyJson.special_requests } else { "" }
                status = "New"
                created_at = (Get-Date).ToString("o")
                updated_at = (Get-Date).ToString("o")
            }

            $bookingList = [System.Collections.Generic.List[PSCustomObject]]@($db.bookings)
            $bookingList.Insert(0, $newBooking)
            $db.bookings = $bookingList
            Save-DB $db

            $msg = "Hello Car Rental Dehradun,%0A%0AI want to book a car.%0A%0ABooking ID: $($newBooking.id)%0ACar: $($newBooking.car_name)%0APickup Location: $($newBooking.pickup_location)%0ADrop Location: $($newBooking.drop_location)%0APickup Date: $($newBooking.pickup_date)%0ADrop Date: $($newBooking.drop_date)%0ANumber of Days: $($newBooking.days)%0ARental Amount: ₹$($newBooking.rental_amount)%0ASecurity Deposit: ₹$($newBooking.security_deposit)%0AEstimated Total: ₹$($newBooking.estimated_total)%0AName: $($newBooking.customer_name)%0AMobile: $($newBooking.customer_phone)%0A%0APlease confirm availability."
            $waUrl = "https://wa.me/91$($db.settings.whatsapp)?text=$msg"

            Send-JsonResponse $response 201 @{
                success = $true
                booking_id = $newBooking.id
                verification_token = $token
                car_name = $newBooking.car_name
                pickup_date = $newBooking.pickup_date
                drop_date = $newBooking.drop_date
                days = $newBooking.days
                rental_amount = $newBooking.rental_amount
                security_deposit = $newBooking.security_deposit
                estimated_total = $newBooking.estimated_total
                whatsapp_url = $waUrl
                phone = $db.settings.phone_display
            }
            continue
        }

        # --- GET /api/bookings/voucher ---
        if ($urlPath -eq "/api/bookings/voucher" -and $httpMethod -eq "GET") {
            $id = $request.QueryString["id"]
            $token = $request.QueryString["token"]
            $booking = $db.bookings | Where-Object { $_.id -eq $id -and $_.verification_token -eq $token } | Select-Object -First 1

            if ($null -eq $booking) {
                Send-JsonResponse $response 404 @{ error = "Voucher not found" }
            } else {
                $msg = "Hello Car Rental Dehradun,%0A%0AI want to confirm my booking.%0ABooking ID: $($booking.id)%0ACar: $($booking.car_name)%0ADates: $($booking.pickup_date) to $($booking.drop_date)%0AName: $($booking.customer_name)"
                $waUrl = "https://wa.me/91$($db.settings.whatsapp)?text=$msg"
                
                $out = [PSCustomObject]@{
                    id = $booking.id
                    car_name = $booking.car_name
                    car_image = $booking.car_image
                    pickup_location = $booking.pickup_location
                    drop_location = $booking.drop_location
                    pickup_date = $booking.pickup_date
                    drop_date = $booking.drop_date
                    pickup_time = $booking.pickup_time
                    days = $booking.days
                    daily_rate = $booking.daily_rate
                    rental_amount = $booking.rental_amount
                    security_deposit = $booking.security_deposit
                    km_limit_per_day = $booking.km_limit_per_day
                    total_km_limit = $booking.total_km_limit
                    extra_km_charge = $booking.extra_km_charge
                    estimated_total = $booking.estimated_total
                    customer_name = $booking.customer_name
                    customer_phone = $booking.customer_phone
                    status = $booking.status
                    whatsapp_url = $waUrl
                    support_phone = $db.settings.phone_display
                    business_name = $db.settings.business_name
                }
                Send-JsonResponse $response 200 $out
            }
            continue
        }

        # --- POST /api/admin/login ---
        if ($urlPath -eq "/api/admin/login" -and $httpMethod -eq "POST") {
            $u = [string]$bodyJson.username
            $p = [string]$bodyJson.password

            if ($u -ne $db.admin.username) {
                Send-JsonResponse $response 401 @{ error = "Invalid credentials" }
                continue
            }

            # Check if default admin123 or valid hash
            $computed = Get-Hash $p $db.admin.salt
            $isValid = ($computed -eq $db.admin.password_hash)
            if (-not $isValid -and ($db.admin.must_change_password -and $p -eq "admin123")) {
                $isValid = $true
            }

            if (-not $isValid) {
                Send-JsonResponse $response 401 @{ error = "Invalid credentials" }
                continue
            }

            $sessToken = [System.Guid]::NewGuid().ToString("N") + [System.Guid]::NewGuid().ToString("N")
            $expiresAt = ([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() + (24 * 3600 * 1000))

            $sessList = [System.Collections.Generic.List[PSCustomObject]]@()
            foreach ($s in @($db.sessions)) {
                if ($s.expires_at -gt [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()) {
                    $sessList.Add($s)
                }
            }
            $sessList.Add([PSCustomObject]@{
                token = $sessToken
                username = $u
                expires_at = $expiresAt
            })
            $db.sessions = $sessList
            $db.admin.last_login = (Get-Date).ToString("o")
            Save-DB $db

            Send-JsonResponse $response 200 @{
                success = $true
                token = $sessToken
                must_change_password = [bool]$db.admin.must_change_password
                expires_at = $expiresAt
            }
            continue
        }

        # Session validation for protected admin endpoints
        $authHeader = $request.Headers["Authorization"]
        $token = if ($authHeader -and $authHeader.StartsWith("Bearer ")) { $authHeader.Substring(7).Trim() } else { $null }
        $session = $null
        if ($token) {
            $nowMs = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
            $session = $db.sessions | Where-Object { $_.token -eq $token -and $_.expires_at -gt $nowMs } | Select-Object -First 1
        }

        if ($null -eq $session) {
            Send-JsonResponse $response 401 @{ error = "Unauthorized: Admin session required" }
            continue
        }

        # --- POST /api/admin/change-password ---
        if ($urlPath -eq "/api/admin/change-password" -and $httpMethod -eq "POST") {
            $newP = [string]$bodyJson.new_password
            if ($newP.Length -lt 8) {
                Send-JsonResponse $response 400 @{ error = "Password must be at least 8 characters" }
                continue
            }

            $newSalt = [System.Guid]::NewGuid().ToString("N")
            $db.admin.salt = $newSalt
            $db.admin.password_hash = Get-Hash $newP $newSalt
            $db.admin.must_change_password = $false
            Save-DB $db

            Send-JsonResponse $response 200 @{ success = $true; message = "Password updated successfully" }
            continue
        }

        # --- GET /api/admin/bookings ---
        if ($urlPath -eq "/api/admin/bookings" -and $httpMethod -eq "GET") {
            Send-JsonResponse $response 200 @($db.bookings) -IsArray
            continue
        }

        # --- PUT /api/admin/bookings/:id/status ---
        if ($urlPath.StartsWith("/api/admin/bookings/") -and $urlPath.EndsWith("/status") -and $httpMethod -eq "PUT") {
            $bId = $urlPath.Replace("/api/admin/bookings/", "").Replace("/status", "")
            $bStatus = [string]$bodyJson.status
            $target = $db.bookings | Where-Object { $_.id -eq $bId } | Select-Object -First 1

            if ($null -eq $target) {
                Send-JsonResponse $response 404 @{ error = "Booking not found" }
            } else {
                $target.status = $bStatus
                $target.updated_at = (Get-Date).ToString("o")
                Save-DB $db
                Send-JsonResponse $response 200 @{ success = $true; booking = $target }
            }
            continue
        }

        # --- POST /api/admin/cars ---
        if ($urlPath -eq "/api/admin/cars" -and $httpMethod -eq "POST") {
            $cName = [string]$bodyJson.name
            $cPrice = [double]$bodyJson.price_per_day
            $slug = "car-" + ($cName.ToLower() -replace "[^a-z0-9]+", "-").Trim("-") + "-" + (Get-Random -Minimum 100 -Maximum 999)

            $newCar = [PSCustomObject]@{
                id = $slug
                name = $cName
                category = if ($bodyJson.category) { [string]$bodyJson.category } else { "Sedan" }
                transmission = if ($bodyJson.transmission) { [string]$bodyJson.transmission } else { "Manual" }
                fuel_type = if ($bodyJson.fuel_type) { [string]$bodyJson.fuel_type } else { "Petrol" }
                seating_capacity = if ($bodyJson.seating_capacity) { [int]$bodyJson.seating_capacity } else { 5 }
                price_per_day = $cPrice
                daily_km_limit = if ($bodyJson.daily_km_limit) { [int]$bodyJson.daily_km_limit } else { 200 }
                extra_km_charge = if ($bodyJson.extra_km_charge) { [double]$bodyJson.extra_km_charge } else { 12 }
                security_deposit = if ($bodyJson.security_deposit) { [double]$bodyJson.security_deposit } else { 3000 }
                min_days = if ($bodyJson.min_days) { [int]$bodyJson.min_days } else { 1 }
                featured = [bool]$bodyJson.featured
                active = $true
                image = if ($bodyJson.image) { [string]$bodyJson.image } else { "images/cars/swift-dzire.webp" }
                gallery = @(if ($bodyJson.image) { [string]$bodyJson.image } else { "images/cars/swift-dzire.webp" })
                short_description = [string]$bodyJson.short_description
                description = [string]$bodyJson.description
                features = @($bodyJson.features)
                why_rent = @($bodyJson.why_rent)
            }

            $carList = [System.Collections.Generic.List[PSCustomObject]]@($db.cars)
            $carList.Add($newCar)
            $db.cars = $carList
            Save-DB $db

            Send-JsonResponse $response 201 @{ success = $true; car = $newCar }
            continue
        }

        # --- PUT /api/admin/cars/:id ---
        if ($urlPath.StartsWith("/api/admin/cars/") -and $httpMethod -eq "PUT") {
            $carId = $urlPath.Substring(16)
            $car = $db.cars | Where-Object { $_.id -eq $carId } | Select-Object -First 1

            if ($null -eq $car) {
                Send-JsonResponse $response 404 @{ error = "Vehicle not found" }
            } else {
                if ($bodyJson.name) { $car.name = [string]$bodyJson.name }
                if ($bodyJson.price_per_day) { $car.price_per_day = [double]$bodyJson.price_per_day }
                if ($bodyJson.daily_km_limit) { $car.daily_km_limit = [int]$bodyJson.daily_km_limit }
                if ($bodyJson.extra_km_charge) { $car.extra_km_charge = [double]$bodyJson.extra_km_charge }
                if ($bodyJson.security_deposit) { $car.security_deposit = [double]$bodyJson.security_deposit }
                if ($bodyJson.transmission) { $car.transmission = [string]$bodyJson.transmission }
                if ($bodyJson.fuel_type) { $car.fuel_type = [string]$bodyJson.fuel_type }
                if ($bodyJson.seating_capacity) { $car.seating_capacity = [int]$bodyJson.seating_capacity }
                if ($bodyJson.category) { $car.category = [string]$bodyJson.category }
                if ($bodyJson.image) { $car.image = [string]$bodyJson.image }
                if ($bodyJson.short_description) { $car.short_description = [string]$bodyJson.short_description }
                if ($bodyJson.description) { $car.description = [string]$bodyJson.description }
                if ($null -ne $bodyJson.active) { $car.active = [bool]$bodyJson.active }
                if ($null -ne $bodyJson.featured) { $car.featured = [bool]$bodyJson.featured }

                Save-DB $db
                Send-JsonResponse $response 200 @{ success = $true; car = $car }
            }
            continue
        }

        # --- DELETE /api/admin/cars/:id ---
        if ($urlPath.StartsWith("/api/admin/cars/") -and $httpMethod -eq "DELETE") {
            $carId = $urlPath.Substring(16)
            $car = $db.cars | Where-Object { $_.id -eq $carId } | Select-Object -First 1

            if ($null -eq $car) {
                Send-JsonResponse $response 404 @{ error = "Vehicle not found" }
            } else {
                $car.active = $false
                Save-DB $db
                Send-JsonResponse $response 200 @{ success = $true; message = "Car deactivated" }
            }
            continue
        }

        # --- PUT /api/admin/settings ---
        if ($urlPath -eq "/api/admin/settings" -and $httpMethod -eq "PUT") {
            if ($bodyJson.settings) {
                $s = $bodyJson.settings
                if ($s.phone) { $db.settings.phone = [string]$s.phone; $db.settings.phone_display = [string]$s.phone }
                if ($s.whatsapp) { $db.settings.whatsapp = [string]$s.whatsapp; $db.settings.whatsapp_display = [string]$s.whatsapp }
                if ($s.default_km_limit) { $db.settings.default_km_limit = [int]$s.default_km_limit }
                if ($s.default_extra_km_charge) { $db.settings.default_extra_km_charge = [double]$s.default_extra_km_charge }
                if ($s.default_security_deposit) { $db.settings.default_security_deposit = [double]$s.default_security_deposit }
                if ($s.seasonal_multiplier) { $db.settings.seasonal_multiplier = [double]$s.seasonal_multiplier }
                if ($s.min_rental_days) { $db.settings.min_rental_days = [int]$s.min_rental_days }
            }
            if ($bodyJson.locations) {
                $db.locations = @($bodyJson.locations)
            }
            Save-DB $db
            Send-JsonResponse $response 200 @{ success = $true; settings = $db.settings; locations = $db.locations }
            continue
        }

        Send-JsonResponse $response 404 @{ error = "API not found" }
        continue
    }

    # Static file serving
    $relPath = $urlPath.TrimStart("/").Replace("/", "\")
    if ([string]::IsNullOrWhiteSpace($relPath)) {
        $relPath = "index.html"
    }

    $fullFilePath = Join-Path $scriptDir $relPath
    if ((Test-Path $fullFilePath) -and (Get-Item $fullFilePath).PSIsContainer) {
        $fullFilePath = Join-Path $fullFilePath "index.html"
    }

    Send-FileResponse $response $fullFilePath
}
