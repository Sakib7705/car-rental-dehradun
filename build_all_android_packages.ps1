$javaHome = 'C:\Users\THOMAS\AppData\Local\jdk17\jdk-17.0.12+7'
$androidHome = 'C:\Users\THOMAS\AppData\Local\Android\Sdk'
$projectDir = 'd:\Car-rental-dehradun.com\android-app'
$artifactsDir = 'd:\Car-rental-dehradun.com\android-build-artifacts'

$env:JAVA_HOME = $javaHome
$env:ANDROID_HOME = $androidHome
$env:PATH = "$javaHome\bin;$androidHome\platform-tools;$androidHome\build-tools\34.0.0;$env:PATH"

Write-Host '====================================================' -ForegroundColor Cyan
Write-Host '  CAR RENTAL DEHRADUN - COMPLETE ANDROID BUILD' -ForegroundColor Cyan
Write-Host '====================================================' -ForegroundColor Cyan

if (-not (Test-Path $artifactsDir)) {
    New-Item -ItemType Directory -Path $artifactsDir -Force | Out-Null
}

Set-Location $projectDir

# 1. Assemble Debug APK
Write-Host "`n[1/3] Building Debug APK (assembleDebug)..." -ForegroundColor Cyan
& cmd.exe /c 'gradlew.bat assembleDebug --stacktrace'
$debugCode = $LASTEXITCODE

# 2. Assemble Release APK
Write-Host "`n[2/3] Building Release APK (assembleRelease)..." -ForegroundColor Cyan
& cmd.exe /c 'gradlew.bat assembleRelease --stacktrace'
$releaseCode = $LASTEXITCODE

# 3. Bundle Release AAB
Write-Host "`n[3/3] Building Release Bundle (bundleRelease)..." -ForegroundColor Cyan
& cmd.exe /c 'gradlew.bat bundleRelease --stacktrace'
$bundleCode = $LASTEXITCODE

Write-Host "`n====================================================" -ForegroundColor Cyan
Write-Host '  COLLECTING AND VERIFYING BUILD ARTIFACTS' -ForegroundColor Cyan
Write-Host '====================================================' -ForegroundColor Cyan

$debugApkSrc = "$projectDir\app\build\outputs\apk\debug\app-debug.apk"
$releaseApkSrc = "$projectDir\app\build\outputs\apk\release\app-release.apk"
$releaseAabSrc = "$projectDir\app\build\outputs\bundle\release\app-release.aab"

$finalDebugApk = "$artifactsDir\CarRentalDehradun-debug.apk"
$finalReleaseApk = "$artifactsDir\CarRentalDehradun-release.apk"
$finalReleaseAab = "$artifactsDir\CarRentalDehradun-release.aab"

# Copy Debug APK
if (Test-Path $debugApkSrc) {
    Copy-Item -Path $debugApkSrc -Destination $finalDebugApk -Force
    $sz = [math]::Round((Get-Item $finalDebugApk).Length / 1MB, 2)
    Write-Host " [SUCCESS] Debug APK: $finalDebugApk ($sz MB)" -ForegroundColor Green
} else {
    Write-Host " [FAILED] Debug APK not found at $debugApkSrc (exit code: $debugCode)" -ForegroundColor Red
}

# Copy Release APK
if (Test-Path $releaseApkSrc) {
    Copy-Item -Path $releaseApkSrc -Destination $finalReleaseApk -Force
    $sz = [math]::Round((Get-Item $finalReleaseApk).Length / 1MB, 2)
    Write-Host " [SUCCESS] Release APK: $finalReleaseApk ($sz MB)" -ForegroundColor Green
} else {
    Write-Host " [FAILED] Release APK not found at $releaseApkSrc (exit code: $releaseCode)" -ForegroundColor Red
}

# Copy Release AAB
if (Test-Path $releaseAabSrc) {
    Copy-Item -Path $releaseAabSrc -Destination $finalReleaseAab -Force
    $sz = [math]::Round((Get-Item $finalReleaseAab).Length / 1MB, 2)
    Write-Host " [SUCCESS] Release AAB: $finalReleaseAab ($sz MB)" -ForegroundColor Green
} else {
    Write-Host " [FAILED] Release AAB not found at $releaseAabSrc (exit code: $bundleCode)" -ForegroundColor Red
}
