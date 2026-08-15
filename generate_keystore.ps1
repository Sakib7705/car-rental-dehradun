$javaHome = "C:\Users\THOMAS\AppData\Local\jdk17\jdk-17.0.12+7"
$keytool = "$javaHome\bin\keytool.exe"
$keystorePath = "d:\Car-rental-dehradun.com\android-app\app\release.keystore"

Write-Host "Creating Release Keystore..." -ForegroundColor Cyan

if (-not (Test-Path $keystorePath)) {
    & $keytool -genkeypair -v `
        -keystore $keystorePath `
        -alias carrentaldehradun `
        -keyalg RSA `
        -keysize 2048 `
        -validity 10000 `
        -storepass "CarRental@2026" `
        -keypass "CarRental@2026" `
        -dname "CN=Car Rental Dehradun, OU=App, O=Car Rental Dehradun, L=Dehradun, ST=Uttarakhand, C=IN"
    Write-Host "Keystore created at: $keystorePath" -ForegroundColor Green
} else {
    Write-Host "Keystore already exists at: $keystorePath" -ForegroundColor Green
}
