$jsDir = "d:\Car-rental-dehradun.com\js"
Get-ChildItem -Path $jsDir -Filter "*.js" | ForEach-Object {
    $filePath = $_.FullName
    $fileName = $_.Name
    $lines = Get-Content $filePath
    $found = @()
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match '(?i)(localhost|127\.0\.0\.1|fetch\(|/api/|apiBase|baseUrl)') {
            $found += "  Line $($i+1): $($lines[$i].Trim())"
        }
    }
    if ($found.Count -gt 0) {
        Write-Host "`n=== File: $fileName ===" -ForegroundColor Cyan
        $found | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
    }
}
