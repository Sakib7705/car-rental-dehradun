$home = $env:USERPROFILE
$configs = @(
    "$home\.ssh\id_rsa",
    "$home\.ssh\id_ed25519",
    "$home\.aws\credentials",
    "$home\.config\gh\hosts.yml",
    "$home\.vercel\auth.json",
    "$home\.railway\config.json",
    "$home\.fly\config.json",
    "$home\.render\config.json",
    "d:\Car-rental-dehradun.com\.env",
    "d:\Car-rental-dehradun.com\deploy.json",
    "d:\Car-rental-dehradun.com\credentials.json"
)

Write-Host "Checking for existing cloud hosting credentials..." -ForegroundColor Cyan
$found = 0
foreach ($p in $configs) {
    if (Test-Path $p) {
        Write-Host " [EXISTS] $p" -ForegroundColor Green
        $found++
    } else {
        Write-Host " [NOT PRESENT] $p" -ForegroundColor Gray
    }
}

# Check relevant environment variables
$cloudEnvs = @("RENDER_API_KEY", "RAILWAY_TOKEN", "VERCEL_TOKEN", "AWS_ACCESS_KEY_ID", "FLY_API_TOKEN", "SSH_AUTH_SOCK", "GITHUB_TOKEN")
foreach ($ev in $cloudEnvs) {
    if ([Environment]::GetEnvironmentVariable($ev)) {
        Write-Host " [ENV SET] $ev" -ForegroundColor Green
        $found++
    }
}

Write-Host "Total cloud credentials found: $found" -ForegroundColor Cyan
