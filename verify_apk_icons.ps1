Add-Type -AssemblyName System.IO.Compression.FileSystem

$apkPath = "d:\Car-rental-dehradun.com\android-build-artifacts\CarRentalDehradun-release.apk"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  VERIFYING LAUNCHER ICONS IN RELEASE APK BINARY" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

if (Test-Path $apkPath) {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($apkPath)
    $iconEntries = $zip.Entries | Where-Object { $_.FullName -match 'ic_launcher' -or $_.FullName -match 'mipmap' }
    
    Write-Host "Found $($iconEntries.Count) icon entries inside Release APK:" -ForegroundColor Green
    foreach ($entry in $iconEntries) {
        Write-Host "  [OK] $($entry.FullName) ($($entry.Length) bytes)" -ForegroundColor Yellow
    }
    $zip.Dispose()
} else {
    Write-Host "[ERROR] APK not found at $apkPath" -ForegroundColor Red
}

Write-Host "`n====================================================" -ForegroundColor Cyan
