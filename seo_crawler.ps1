# Automated SEO & Crawler Quality Audit Script
param([int]$Port = 3000)

$baseUrl = "http://localhost:$Port"
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  UTTARAKHAND-WIDE SEO PLATFORM AUDIT & CRAWLER" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

$allHtmlFiles = Get-ChildItem -Path $PSScriptRoot -Filter "*.html" -Recurse | Where-Object { 
    $_.FullName -notmatch '\\scratch\\' -and 
    $_.FullName -notmatch '\\android-app\\' -and 
    $_.FullName -notmatch '\\\.system_generated\\' -and 
    $_.Name -ne 'template.html' 
}

Write-Host "Found $($allHtmlFiles.Count) HTML pages to audit across the project." -ForegroundColor Yellow

$auditResults = @()
$brokenLinks = @()
$schemaErrors = @()

foreach ($file in $allHtmlFiles) {
    $relPath = $file.FullName.Substring($PSScriptRoot.Length + 1).Replace("\", "/")
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. Title check
    $hasTitle = $content -match '<title>(.*?)</title>'
    $title = if ($hasTitle) { $matches[1] } else { "" }
    
    # 2. Meta description check
    $hasDesc = $content -match '<meta\s+name=["'']description["'']\s+content=["''](.*?)["'']'
    $desc = if ($hasDesc) { $matches[1] } else { "" }
    
    # 3. Canonical link check
    $hasCanonical = $content -match '<link\s+rel=["'']canonical["'']\s+href=["''](.*?)["'']'
    $canonical = if ($hasCanonical) { $matches[1] } else { "" }

    # 4. Viewport check
    $hasViewport = $content -match '<meta\s+name=["'']viewport["'']'

    # 5. Schema JSON-LD validation
    $schemaMatches = [regex]::Matches($content, '<script\s+type=["'']application/ld\+json["'']>([\s\S]*?)</script>')
    $schemaCount = $schemaMatches.Count
    $schemaValid = $true
    foreach ($sm in $schemaMatches) {
        $jsonRaw = $sm.Groups[1].Value.Trim()
        try {
            $parsed = $jsonRaw | ConvertFrom-Json
        } catch {
            $schemaValid = $false
            $schemaErrors += "${relPath} - Schema parsing error: $($_.Exception.Message)"
        }
    }

    # 6. HTTP 200 Live check
    $httpStatus = 0
    try {
        $res = Invoke-WebRequest -Uri "$baseUrl/$relPath" -UseBasicParsing -TimeoutSec 3
        $httpStatus = $res.StatusCode
    } catch {
        $httpStatus = if ($_.Exception.Response) { $_.Exception.Response.StatusCode.value__ } else { 500 }
        $brokenLinks += "${relPath} -> HTTP $httpStatus"
    }

    $auditResults += [PSCustomObject]@{
        Page = $relPath
        Status = $httpStatus
        TitleLength = $title.Length
        DescLength = $desc.Length
        HasCanonical = $hasCanonical
        HasViewport = $hasViewport
        SchemaBlocks = $schemaCount
        SchemaValid = $schemaValid
    }
}

Write-Host "`nCRAWL AUDIT SUMMARY:" -ForegroundColor Cyan
Write-Host "Total Pages Audited: $($auditResults.Count)"
Write-Host "HTTP 200 Status OK: $(($auditResults | Where-Object { $_.Status -eq 200 }).Count) / $($auditResults.Count)"
Write-Host "Valid Schema.org Blocks: $(($auditResults | Where-Object { $_.SchemaValid -eq $true }).Count) / $($auditResults.Count)"
Write-Host "Mobile Viewport Configured: $(($auditResults | Where-Object { $_.HasViewport -eq $true }).Count) / $($auditResults.Count)"

if ($brokenLinks.Count -gt 0) {
    Write-Host "`nBroken Links / Routes:" -ForegroundColor Red
    $brokenLinks | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
} else {
    Write-Host "`nZero Broken Links Detected across all $($auditResults.Count) pages!" -ForegroundColor Green
}

if ($schemaErrors.Count -gt 0) {
    Write-Host "`nSchema.org Errors:" -ForegroundColor Red
    $schemaErrors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
} else {
    Write-Host "All Schema.org JSON-LD parsed perfectly!" -ForegroundColor Green
}

Write-Host "`n====================================================" -ForegroundColor Cyan
