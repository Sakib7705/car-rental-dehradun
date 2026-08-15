Write-Host "Checking Android & Build Tools..." -ForegroundColor Cyan

$toolNames = @("android", "gradle", "adb", "javac", "java", "node", "npm", "npx", "keytool")
foreach ($t in $toolNames) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host " [AVAILABLE] $t -> $($cmd.Source)" -ForegroundColor Green
    } else {
        Write-Host " [NOT FOUND] $t" -ForegroundColor Yellow
    }
}

Write-Host "`nEnvironment Variables:" -ForegroundColor Cyan
Write-Host " ANDROID_HOME: $env:ANDROID_HOME"
Write-Host " ANDROID_SDK_ROOT: $env:ANDROID_SDK_ROOT"
Write-Host " JAVA_HOME: $env:JAVA_HOME"

# Check standard Android SDK locations on Windows
$commonSdkPaths = @(
    "$env:LOCALAPPDATA\Android\Sdk",
    "$env:ProgramFiles\Android\Android Studio",
    "$env:ProgramFiles(x86)\Android\android-sdk",
    "C:\Android\Sdk",
    "$env:USERPROFILE\AppData\Local\Android\Sdk"
)

Write-Host "`nChecking Common Android SDK Locations:" -ForegroundColor Cyan
foreach ($p in $commonSdkPaths) {
    if (Test-Path $p) {
        Write-Host " [FOUND] $p" -ForegroundColor Green
        if (Test-Path "$p\build-tools") {
            $bt = Get-ChildItem "$p\build-tools" | Select-Object -ExpandProperty Name
            Write-Host "   Build tools: $($bt -join ', ')" -ForegroundColor Gray
        }
        if (Test-Path "$p\platforms") {
            $pf = Get-ChildItem "$p\platforms" | Select-Object -ExpandProperty Name
            Write-Host "   Platforms: $($pf -join ', ')" -ForegroundColor Gray
        }
    }
}

# Check common Java / JDK locations
$commonJdkPaths = @(
    "$env:ProgramFiles\Java",
    "$env:ProgramFiles\Eclipse Adoptium",
    "$env:ProgramFiles\Microsoft\jdk*",
    "$env:ProgramFiles\Android\Android Studio\jbr",
    "$env:ProgramFiles\Android\Android Studio\jre"
)

Write-Host "`nChecking Common JDK / JBR Locations:" -ForegroundColor Cyan
foreach ($p in $commonJdkPaths) {
    $found = Get-Item $p -ErrorAction SilentlyContinue
    if ($found) {
        foreach ($j in $found) {
            Write-Host " [FOUND] $($j.FullName)" -ForegroundColor Green
        }
    }
}
