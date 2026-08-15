$artDir = 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479'
$carsDir = 'D:\Car-rental-dehradun.com\images\cars'

$items = @(
    @{ Pattern = 'swift_car_red*.jpg'; Target = 'swift.jpg' },
    @{ Pattern = 'swift_dzire_car*.jpg'; Target = 'swift-dzire.jpg' },
    @{ Pattern = 'ertiga_car*.jpg'; Target = 'ertiga.jpg' },
    @{ Pattern = 'scorpio_n_car*.jpg'; Target = 'scorpio-n.jpg' },
    @{ Pattern = 'thar_car_red*.jpg'; Target = 'thar.jpg' },
    @{ Pattern = 'sonet_car_blue*.jpg'; Target = 'kia-sonet.jpg' },
    @{ Pattern = 'venue_car_grey*.jpg'; Target = 'hyundai-venue.jpg' },
    @{ Pattern = 'baleno_car_blue*.jpg'; Target = 'maruti-baleno.jpg' },
    @{ Pattern = 'glanza_car_red*.jpg'; Target = 'toyota-glanza.jpg' },
    @{ Pattern = 'i20_car_silver*.jpg'; Target = 'hyundai-i20.jpg' },
    @{ Pattern = 'i20_auto_white*.jpg'; Target = 'hyundai-i20-auto.jpg' }
)

foreach ($item in $items) {
    $src = Get-ChildItem -Path $artDir -Filter $item.Pattern | Select-Object -First 1
    if ($src) {
        $dest = Join-Path $carsDir $item.Target
        Copy-Item $src.FullName $dest -Force
        Write-Host "Copied $($src.Name) -> $($item.Target) ($([math]::Round($src.Length/1KB, 1)) KB)" -ForegroundColor Green
    } else {
        Write-Host "NOT FOUND: $($item.Pattern)" -ForegroundColor Red
    }
}
