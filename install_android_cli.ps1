$tempCmd = Join-Path $env:TEMP 'install_android.cmd'
Write-Host "Downloading Android CLI installer to $tempCmd..." -ForegroundColor Cyan
curl.exe -fsSL 'https://dl.google.com/android/cli/latest/windows_x86_64/install.cmd' -o $tempCmd

if (Test-Path $tempCmd) {
    Write-Host "Running installer..." -ForegroundColor Green
    & cmd.exe /c $tempCmd
    Write-Host "Installer finished." -ForegroundColor Green
} else {
    Write-Host "Failed to download installer." -ForegroundColor Red
}
