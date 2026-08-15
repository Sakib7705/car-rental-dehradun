$javaHome = "C:\Users\THOMAS\AppData\Local\jdk17\jdk-17.0.12+7"
$androidHome = "C:\Users\THOMAS\AppData\Local\Android\Sdk"
$projectDir = "d:\Car-rental-dehradun.com\android-app"

$env:JAVA_HOME = $javaHome
$env:ANDROID_HOME = $androidHome
$env:PATH = "$javaHome\bin;$androidHome\platform-tools;$androidHome\build-tools\34.0.0;$env:PATH"

Write-Host "Building Car Rental Dehradun Android Project..." -ForegroundColor Cyan
Write-Host "JAVA_HOME: $env:JAVA_HOME"
Write-Host "ANDROID_HOME: $env:ANDROID_HOME"

Set-Location $projectDir

Write-Host "`n--- Running AssembleDebug ---" -ForegroundColor Cyan
& cmd.exe /c "gradlew.bat assembleDebug --stacktrace"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n AssembleDebug SUCCESSFUL!" -ForegroundColor Green
} else {
    Write-Host "`n AssembleDebug FAILED with code $LASTEXITCODE" -ForegroundColor Red
}

Write-Host "`n--- Running BundleRelease (AAB) ---" -ForegroundColor Cyan
& cmd.exe /c "gradlew.bat bundleRelease --stacktrace"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n BundleRelease (AAB) SUCCESSFUL!" -ForegroundColor Green
} else {
    Write-Host "`n BundleRelease (AAB) FAILED with code $LASTEXITCODE" -ForegroundColor Red
}
