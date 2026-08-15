$root = "d:\Car-rental-dehradun.com"

Write-Host "Scanning for any localhost or 127.0.0.1 references in code files..." -ForegroundColor Cyan

$exts = @(".html", ".js", ".json", ".kt", ".java", ".xml", ".kts", ".webmanifest")

$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
    $exts -contains $_.Extension -and
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -notmatch '\\\.system_generated\\' -and
    $_.FullName -notmatch '\\scratch\\' -and
    $_.FullName -notmatch '\\android-app\\\.gradle\\' -and
    $_.FullName -notmatch '\\android-app\\app\\build\\'
}

$foundItems = @()

foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Length + 1)
    $content = [System.IO.File]::ReadAllText($f.FullName)
    if ($content -match '(?i)(localhost|127\.0\.0\.1)') {
        $lines = $content -split "`r?`n"
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match '(?i)(localhost|127\.0\.0\.1)') {
                $foundItems += [PSCustomObject]@{
                    File = $rel
                    Line = ($i + 1)
                    Content = $lines[$i].Trim()
                }
            }
        }
    }
}

Write-Host "`nTotal matches found: $($foundItems.Count)" -ForegroundColor Cyan
foreach ($item in $foundItems) {
    Write-Host "[$($item.File):$($item.Line)] $($item.Content)" -ForegroundColor Yellow
}
