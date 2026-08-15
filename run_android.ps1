$androidExe = 'C:\Users\THOMAS\AppData\AndroidCLI\android.exe'
Write-Host "Listing available SDK packages..." -ForegroundColor Cyan
& $androidExe sdk list --all
