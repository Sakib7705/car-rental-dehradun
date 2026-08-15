$jsFiles = Get-ChildItem -Path "d:\Car-rental-dehradun.com\js" -Filter "*.js"
foreach ($file in $jsFiles) {
    $lines = Get-Content $file.FullName
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match 'toLocaleString|formatDate|Booking Lookup|initConfirmation|initBookingLookup|voucher') {
            Write-Host "$($file.Name):$($i+1)  $($lines[$i].Trim())" -ForegroundColor Yellow
        }
    }
}
