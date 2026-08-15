$domain = "car-rental-dehradun.com"
$prodUrl = "https://car-rental-dehradun.com/api/cars"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  CHECKING INTERNET / PRODUCTION DOMAIN STATUS" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. DNS Lookup
Write-Host "`n1. DNS Resolution Test for $domain..." -ForegroundColor Yellow
try {
    $dns = [System.Net.Dns]::GetHostAddresses($domain)
    Write-Host "  [DNS SUCCESS] Resolved IP(s): $(($dns | ForEach-Object { $_.IPAddressToString }) -join ', ')" -ForegroundColor Green
} catch {
    Write-Host "  [DNS FAILED] Could not resolve host '$domain': $($_.Exception.Message)" -ForegroundColor Red
}

# 2. HTTPS Connection Test
Write-Host "`n2. HTTPS API Endpoint Test: $prodUrl..." -ForegroundColor Yellow
try {
    $req = [System.Net.HttpWebRequest]::Create($prodUrl)
    $req.Timeout = 8000
    $req.Method = "GET"
    $resp = $req.GetResponse()
    $status = [int]$resp.StatusCode
    Write-Host "  [HTTPS SUCCESS] Status code: $status" -ForegroundColor Green
    $resp.Close()
} catch {
    Write-Host "  [HTTPS FAILED] Exception: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n====================================================" -ForegroundColor Cyan
