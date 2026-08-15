$root = "d:\Car-rental-dehradun.com"
$buildOutputDir = Join-Path $root "android-build-artifacts"

if (-not (Test-Path $buildOutputDir)) {
    New-Item -ItemType Directory -Path $buildOutputDir -Force | Out-Null
}

Write-Host "Verifying Android Build Artifacts..." -ForegroundColor Cyan

# 1. Debug APK
$debugApkSrc = "d:\Car-rental-dehradun.com\android-app\app\build\outputs\apk\debug\app-debug.apk"
if (Test-Path $debugApkSrc) {
    $destApk = Join-Path $buildOutputDir "CarRentalDehradun-debug.apk"
    Copy-Item -Path $debugApkSrc -Destination $destApk -Force
    $sizeMb = [math]::Round((Get-Item $destApk).Length / 1MB, 2)
    Write-Host " [FOUND & COPIED] Debug APK: $destApk ($sizeMb MB)" -ForegroundColor Green
} else {
    Write-Host " [NOT FOUND] Debug APK at $debugApkSrc" -ForegroundColor Red
}

# 2. Release AAB
$releaseAabSrc = "d:\Car-rental-dehradun.com\android-app\app\build\outputs\bundle\release\app-release.aab"
if (Test-Path $releaseAabSrc) {
    $destAab = Join-Path $buildOutputDir "CarRentalDehradun-release.aab"
    Copy-Item -Path $releaseAabSrc -Destination $destAab -Force
    $sizeMb = [math]::Round((Get-Item $destAab).Length / 1MB, 2)
    Write-Host " [FOUND & COPIED] Release AAB: $destAab ($sizeMb MB)" -ForegroundColor Green
} else {
    Write-Host " [NOT FOUND] Release AAB at $releaseAabSrc" -ForegroundColor Red
}

# List all files in the build output directory
Write-Host ""
Write-Host "All Build Artifacts in $buildOutputDir :" -ForegroundColor Cyan
Get-ChildItem -Path $buildOutputDir | ForEach-Object {
    $sz = [math]::Round($_.Length / 1MB, 2)
    Write-Host " -> $($_.Name) ($sz MB)" -ForegroundColor Yellow
}
