$tools = @("git", "curl", "npm", "npx", "node", "vercel", "flyctl", "railway", "gh", "ssh", "firebase")
foreach ($t in $tools) {
    $cmd = Get-Command $t -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "[AVAILABLE] $t -> $($cmd.Source)" -ForegroundColor Green
    } else {
        Write-Host "[NOT FOUND] $t" -ForegroundColor Yellow
    }
}
