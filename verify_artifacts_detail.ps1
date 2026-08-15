$artifacts = @(
    "d:\Car-rental-dehradun.com\android-build-artifacts\CarRentalDehradun-debug.apk",
    "d:\Car-rental-dehradun.com\android-build-artifacts\CarRentalDehradun-release.apk",
    "d:\Car-rental-dehradun.com\android-build-artifacts\CarRentalDehradun-release.aab"
)

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  DETAILED ARTIFACT VERIFICATION" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

foreach ($art in $artifacts) {
    if (Test-Path $art) {
        $item = Get-Item $art
        $hash = Get-FileHash -Path $art -Algorithm SHA256
        Write-Host "`nFile: $($item.Name)" -ForegroundColor Green
        Write-Host "  Full Path:    $($item.FullName)"
        Write-Host "  Size (Bytes): $($item.Length)"
        Write-Host "  Size (MB):    $([math]::Round($item.Length / 1MB, 2)) MB"
        Write-Host "  SHA-256:      $($hash.Hash)"
        Write-Host "  Last Write:   $($item.LastWriteTime)"
    } else {
        Write-Host "`n[MISSING] $art" -ForegroundColor Red
    }
}
Write-Host "`n====================================================" -ForegroundColor Cyan
