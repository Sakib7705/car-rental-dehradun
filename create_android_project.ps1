$androidExe = 'C:\Users\THOMAS\AppData\AndroidCLI\android.exe'
$outDir = 'd:\Car-rental-dehradun.com\android-app'

Write-Host "Creating Android App project at $outDir with verbose..." -ForegroundColor Cyan

& $androidExe create empty-activity --name="Car Rental Dehradun" --output=$outDir --verbose
