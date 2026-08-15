$srcRoot = "d:\Car-rental-dehradun.com"
$assetsDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\assets"

Write-Host "Preparing Android Web Assets in $assetsDir..." -ForegroundColor Cyan

if (Test-Path $assetsDir) { Remove-Item $assetsDir -Recurse -Force }
New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null

$itemsToCopy = @(
    "index.html",
    "cars.html",
    "car-details.html",
    "book.html",
    "about.html",
    "contact.html",
    "terms.html",
    "privacy.html",
    "cancellation.html",
    "faq.html",
    "manifest.webmanifest",
    "sw.js",
    "css",
    "js",
    "images",
    "data",
    "destinations",
    "locations",
    "travel-guides"
)

foreach ($item in $itemsToCopy) {
    $src = Join-Path $srcRoot $item
    $dest = Join-Path $assetsDir $item
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dest -Recurse -Force
        Write-Host " [COPIED] $item" -ForegroundColor Green
    } else {
        Write-Host " [MISSING] $item" -ForegroundColor Yellow
    }
}

Write-Host "Assets preparation complete!" -ForegroundColor Cyan
