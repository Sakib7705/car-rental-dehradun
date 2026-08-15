$srcDir = "d:\Car-rental-dehradun.com"
$destDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\assets"

Write-Host "Syncing web assets to Android package assets..." -ForegroundColor Cyan

if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}

$excludeDirs = @(".git", ".system_generated", "scratch", "android-app", "android-build-artifacts", "node_modules", ".gemini")
$excludeExts = @(".ps1", ".keystore", ".log")

Get-ChildItem -Path $srcDir -Recurse | ForEach-Object {
    $item = $_
    $relPath = $item.FullName.Substring($srcDir.Length).TrimStart('\', '/')
    
    # Check if inside excluded directory
    $skip = $false
    foreach ($ex in $excludeDirs) {
        if ($relPath -eq $ex -or $relPath.StartsWith("$ex\") -or $relPath.StartsWith("$ex/")) {
            $skip = $true
            break
        }
    }
    
    if (-not $skip) {
        if ($item.PSIsContainer) {
            $targetPath = Join-Path $destDir $relPath
            if (-not (Test-Path $targetPath)) {
                New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
            }
        } else {
            if ($excludeExts -notcontains $item.Extension) {
                $targetPath = Join-Path $destDir $relPath
                $parentDir = Split-Path $targetPath -Parent
                if (-not (Test-Path $parentDir)) {
                    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                }
                Copy-Item -Path $item.FullName -Destination $targetPath -Force
            }
        }
    }
}

Write-Host "Sync complete! Android assets are up to date." -ForegroundColor Green
