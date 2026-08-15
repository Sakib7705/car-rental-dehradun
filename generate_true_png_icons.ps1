Add-Type -AssemblyName System.Drawing

function Render-CarRentalIcon([int]$size, [string]$outputPath) {
    $bmp = [System.Drawing.Bitmap]::new($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    # 1. Background Rounded Circle
    $rect = [System.Drawing.Rectangle]::new(0, 0, $size, $size)
    $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new($rect, [System.Drawing.Color]::FromArgb(4, 47, 46), [System.Drawing.Color]::FromArgb(15, 118, 110), 45.0)
    $g.FillEllipse($brush, 2, 2, ($size - 4), ($size - 4))
    $brush.Dispose()
    
    # 2. Golden Border
    $penWidth = [single][math]::Max(2, $size / 24)
    $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(245, 158, 11), $penWidth)
    $g.DrawEllipse($pen, 2, 2, ($size - 4), ($size - 4))
    $pen.Dispose()
    
    # 3. Text CRD
    $fontSize = [single]($size * 0.28)
    $font = [System.Drawing.Font]::new("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    $g.DrawString("CRD", $font, $textBrush, [single]($size / 2), [single]($size * 0.42), $sf)
    
    # Subtitle
    $subFontSize = [single]($size * 0.11)
    $subFont = [System.Drawing.Font]::new("Arial", $subFontSize, [System.Drawing.FontStyle]::Bold)
    $goldBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(245, 158, 11))
    $g.DrawString("CAR RENTAL", $subFont, $goldBrush, [single]($size / 2), [single]($size * 0.72), $sf)
    
    $font.Dispose()
    $subFont.Dispose()
    $textBrush.Dispose()
    $goldBrush.Dispose()
    $sf.Dispose()
    $g.Dispose()
    
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$resDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\res"
$densities = @(
    @{ Folder = "mipmap-mdpi"; Size = 48 },
    @{ Folder = "mipmap-hdpi"; Size = 72 },
    @{ Folder = "mipmap-xhdpi"; Size = 96 },
    @{ Folder = "mipmap-xxhdpi"; Size = 144 },
    @{ Folder = "mipmap-xxxhdpi"; Size = 192 }
)

foreach ($d in $densities) {
    $folder = Join-Path $resDir $d.Folder
    if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }
    
    $pngPath = Join-Path $folder "ic_launcher.png"
    $roundPngPath = Join-Path $folder "ic_launcher_round.png"
    
    Render-CarRentalIcon $d.Size $pngPath
    Render-CarRentalIcon $d.Size $roundPngPath
    Write-Host " [OK] Generated $($d.Folder) icons (${d.Size}x${d.Size})" -ForegroundColor Green
}

# Also update web icon-192.png and icon-512.png as real binary PNGs
Render-CarRentalIcon 192 "d:\Car-rental-dehradun.com\images\icons\icon-192.png"
Render-CarRentalIcon 512 "d:\Car-rental-dehradun.com\images\icons\icon-512.png"
Render-CarRentalIcon 192 "d:\Car-rental-dehradun.com\android-app\app\src\main\assets\images\icons\icon-192.png"
Render-CarRentalIcon 512 "d:\Car-rental-dehradun.com\android-app\app\src\main\assets\images\icons\icon-512.png"
Write-Host "All Android & Web PNG icons rendered successfully!" -ForegroundColor Cyan
