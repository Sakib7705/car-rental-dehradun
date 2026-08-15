$appJavaDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\java"
$pkgDir = Join-Path $appJavaDir "com\carrentaldehradun\app"

Write-Host "Setting up package structure: com.carrentaldehradun.app..." -ForegroundColor Cyan

# Remove old template files
$exampleDir = Join-Path $appJavaDir "com\example"
if (Test-Path $exampleDir) { Remove-Item $exampleDir -Recurse -Force }

# Remove old test template files
$testDir = "d:\Car-rental-dehradun.com\android-app\app\src\test"
if (Test-Path $testDir) { Remove-Item $testDir -Recurse -Force }
$androidTestDir = "d:\Car-rental-dehradun.com\android-app\app\src\androidTest"
if (Test-Path $androidTestDir) { Remove-Item $androidTestDir -Recurse -Force }

if (-not (Test-Path $pkgDir)) {
    New-Item -ItemType Directory -Path $pkgDir -Force | Out-Null
}

Write-Host "Directory $pkgDir ready." -ForegroundColor Green
