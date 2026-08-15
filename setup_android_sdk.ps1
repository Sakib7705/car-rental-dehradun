$androidExe = 'C:\Users\THOMAS\AppData\AndroidCLI\android.exe'
Write-Host "Installing Android SDK Platform 34, Build Tools 34.0.0, Platform Tools & Cmdline Tools..." -ForegroundColor Cyan

& $androidExe sdk install platforms/android-34 build-tools/34.0.0 platform-tools cmdline-tools/latest
