$jdkZip = Join-Path $env:TEMP "openjdk17.zip"
$jdkTargetDir = "C:\Users\THOMAS\AppData\Local\jdk17"
$downloadUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.12_7.zip"

Write-Host "Downloading portable OpenJDK 17 from Adoptium..." -ForegroundColor Cyan
curl.exe -L -fsSL $downloadUrl -o $jdkZip

if (Test-Path $jdkZip) {
    Write-Host "Downloaded ($([math]::Round((Get-Item $jdkZip).Length / 1MB, 1)) MB). Extracting to $jdkTargetDir..." -ForegroundColor Green
    if (Test-Path $jdkTargetDir) { Remove-Item $jdkTargetDir -Recurse -Force }
    New-Item -ItemType Directory -Path $jdkTargetDir -Force | Out-Null
    
    Expand-Archive -Path $jdkZip -DestinationPath $jdkTargetDir -Force
    
    # Find bin/java.exe
    $subDir = Get-ChildItem -Path $jdkTargetDir -Directory | Select-Object -First 1
    if ($subDir) {
        $actualHome = $subDir.FullName
        Write-Host "OpenJDK 17 Installed successfully at: $actualHome" -ForegroundColor Green
        & "$actualHome\bin\java.exe" -version
    }
} else {
    Write-Host "Failed to download OpenJDK zip." -ForegroundColor Red
}
