$wg = Get-Command "winget.exe" -ErrorAction SilentlyContinue
if ($wg) {
    Write-Host "winget found: $($wg.Source)" -ForegroundColor Green
} else {
    Write-Host "winget not in PATH" -ForegroundColor Yellow
}

# Also search for any existing java.exe on drive C:
Write-Host "Searching for any existing Java on system..." -ForegroundColor Cyan
$j = Get-ChildItem -Path "C:\Program Files", "C:\Users\THOMAS\AppData\Local", "C:\Android" -Filter "java.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 5
foreach ($item in $j) {
    Write-Host "Found java at: $($item.FullName)" -ForegroundColor Green
}
