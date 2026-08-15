$resDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\res"

Write-Host "Removing duplicate .webp icons from mipmap folders..." -ForegroundColor Cyan
Get-ChildItem -Path $resDir -Filter "*.webp" -Recurse | ForEach-Object {
    Write-Host " [REMOVED] $($_.FullName)" -ForegroundColor Yellow
    Remove-Item $_.FullName -Force
}

Write-Host "Mipmap cleanup done. Only crisp PNG icons remain." -ForegroundColor Green
