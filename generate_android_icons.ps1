Add-Type -AssemblyName System.Drawing

$srcIcon = "d:\Car-rental-dehradun.com\images\icons\icon-512.png"
$resDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\res"

$densities = @(
    @{ Folder = "mipmap-mdpi"; Size = 48 },
    @{ Folder = "mipmap-hdpi"; Size = 72 },
    @{ Folder = "mipmap-xhdpi"; Size = 96 },
    @{ Folder = "mipmap-xxhdpi"; Size = 144 },
    @{ Folder = "mipmap-xxxhdpi"; Size = 192 }
)

Write-Host "Generating Android launcher icons from $srcIcon..." -ForegroundColor Cyan

$srcImg = [System.Drawing.Image]::FromFile($srcIcon)

foreach ($d in $densities) {
    $targetFolder = Join-Path $resDir $d.Folder
    if (-not (Test-Path $targetFolder)) {
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    }
    
    $sz = $d.Size
    $bmp = New-Object System.Drawing.Bitmap $sz, $sz
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    
    $g.DrawImage($srcImg, 0, 0, $sz, $sz)
    $g.Dispose()
    
    # Save standard icon and round icon (both as PNG/WebP)
    $outPng = Join-Path $targetFolder "ic_launcher.png"
    $outRoundPng = Join-Path $targetFolder "ic_launcher_round.png"
    $bmp.Save($outPng, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Save($outRoundPng, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    
    Write-Host " [OK] Generated $($d.Folder)/ic_launcher.png (${sz}x${sz})" -ForegroundColor Green
}

$srcImg.Dispose()
Write-Host "Launcher icons generated successfully!" -ForegroundColor Cyan
