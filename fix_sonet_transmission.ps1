$filesToUpdate = Get-ChildItem -Path . -Include *.html,*.json,*.js -Recurse | Where-Object { $_.FullName -notmatch '\\(\.git|node_modules)\\' }

foreach ($file in $filesToUpdate) {
    $content = Get-Content $file.FullName -Raw
    $modified = $false
    
    if ($content -match 'Kia Sonet Automatic') {
        $content = $content.Replace('Kia Sonet Automatic', 'Kia Sonet Manual')
        $modified = $true
    }
    if ($content -match 'Kia Sonet \(Automatic\)') {
        $content = $content.Replace('Kia Sonet (Automatic)', 'Kia Sonet (Manual)')
        $modified = $true
    }
    if ($content -match 'Kia Sonet AT') {
        $content = $content.Replace('Kia Sonet AT', 'Kia Sonet Manual')
        $modified = $true
    }
    if ($content -match 'automatic cars like the Kia Sonet, Hyundai i20 Automatic') {
        $content = $content.Replace('automatic cars like the Kia Sonet, Hyundai i20 Automatic', 'automatic cars like the Hyundai i20 Automatic')
        $modified = $true
    }
    
    if ($modified) {
        $content | Set-Content $file.FullName -Encoding UTF8
        Write-Host "Updated Sonet transmission in: $($file.Name)" -ForegroundColor Green
    }
}
