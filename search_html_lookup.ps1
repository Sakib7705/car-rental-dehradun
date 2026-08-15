Get-ChildItem -Path "d:\Car-rental-dehradun.com" -Filter "*.html" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '(?i)(lookup|voucher|confirmation)') {
        Write-Host "$($_.Name)" -ForegroundColor Cyan
    }
}
