Add-Type -AssemblyName System.Drawing

$resDir = "d:\Car-rental-dehradun.com\android-app\app\src\main\res"

$densities = @(
    @{ Name = "mipmap-mdpi"; Size = 48 },
    @{ Name = "mipmap-hdpi"; Size = 72 },
    @{ Name = "mipmap-xhdpi"; Size = 96 },
    @{ Name = "mipmap-xxhdpi"; Size = 144 },
    @{ Name = "mipmap-xxxhdpi"; Size = 192 }
)

function Draw-CarRentalIcon([int]$size, [bool]$isRound) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    # 1. Background Path
    $bgPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $margin = [math]::Max(1.0, $size * 0.02)
    $w = $size - ($margin * 2)
    $h = $size - ($margin * 2)
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $h)

    if ($isRound) {
        $bgPath.AddEllipse($rect)
    } else {
        # Squircle / rounded rectangle
        $radius = $size * 0.22
        $d = $radius * 2
        $bgPath.AddArc($rect.X, $rect.Y, $d, $d, 180, 90)
        $bgPath.AddArc($rect.Right - $d, $rect.Y, $d, $d, 270, 90)
        $bgPath.AddArc($rect.Right - $d, $rect.Bottom - $d, $d, $d, 0, 90)
        $bgPath.AddArc($rect.X, $rect.Bottom - $d, $d, $d, 90, 90)
        $bgPath.CloseFigure()
    }

    # Gradient Brush
    $colorTop = [System.Drawing.Color]::FromArgb(255, 4, 47, 46)     # Deep Emerald #042F2E
    $colorBottom = [System.Drawing.Color]::FromArgb(255, 15, 118, 110) # Rich Teal #0F766E
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $colorTop, $colorBottom, 45.0)
    $g.FillPath($brush, $bgPath)

    # Outer border ring
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(80, 45, 212, 191), [math]::Max(1.5, $size * 0.03))
    $g.DrawPath($borderPen, $bgPath)

    # 2. GPS Pin / Rental Emblem at Top
    $pinX = $size * 0.50
    $pinY = $size * 0.23
    $pinSize = $size * 0.16
    $amberBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 245, 158, 11)) # #F59E0B
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $darkTealBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 4, 47, 46))
    $cyanBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 212, 191))

    # Draw pin
    $pinRect = New-Object System.Drawing.RectangleF(($pinX - $pinSize/2), ($pinY - $pinSize/2), $pinSize, $pinSize)
    $g.FillEllipse($amberBrush, $pinRect)
    $innerPinSize = $pinSize * 0.4
    $innerPinRect = New-Object System.Drawing.RectangleF(($pinX - $innerPinSize/2), ($pinY - $innerPinSize/2), $innerPinSize, $innerPinSize)
    $g.FillEllipse($whiteBrush, $innerPinRect)

    # 3. Modern Car Silhouette (Vector Coordinates scaled to $size)
    $scale = $size / 100.0
    
    # Roof & Windshield
    $roofPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $roofPoints = @(
        (New-Object System.Drawing.PointF((36 * $scale), (47 * $scale))),
        (New-Object System.Drawing.PointF((41 * $scale), (36 * $scale))),
        (New-Object System.Drawing.PointF((59 * $scale), (36 * $scale))),
        (New-Object System.Drawing.PointF((64 * $scale), (47 * $scale)))
    )
    $roofPath.AddPolygon($roofPoints)
    $g.FillPath($whiteBrush, $roofPath)

    # Windshield Glass (dark emerald)
    $glassPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $glassPoints = @(
        (New-Object System.Drawing.PointF((38.5 * $scale), (45.5 * $scale))),
        (New-Object System.Drawing.PointF((43 * $scale), (38 * $scale))),
        (New-Object System.Drawing.PointF((57 * $scale), (38 * $scale))),
        (New-Object System.Drawing.PointF((61.5 * $scale), (45.5 * $scale)))
    )
    $glassPath.AddPolygon($glassPoints)
    $g.FillPath($darkTealBrush, $glassPath)

    # Main Car Body
    $bodyPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $bodyRect = New-Object System.Drawing.RectangleF((23 * $scale), (46 * $scale), (54 * $scale), (22 * $scale))
    $bRadius = 4 * $scale
    $bD = $bRadius * 2
    $bodyPath.AddArc($bodyRect.X, $bodyRect.Y, $bD, $bD, 180, 90)
    $bodyPath.AddArc($bodyRect.Right - $bD, $bodyRect.Y, $bD, $bD, 270, 90)
    $bodyPath.AddArc($bodyRect.Right - $bD, $bodyRect.Bottom - $bD, $bD, $bD, 0, 90)
    $bodyPath.AddArc($bodyRect.X, $bodyRect.Bottom - $bD, $bD, $bD, 90, 90)
    $bodyPath.CloseFigure()
    $g.FillPath($whiteBrush, $bodyPath)

    # Wheels / Under-fenders
    $wheelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 30, 41, 59))
    $g.FillRectangle($wheelBrush, (27 * $scale), (66 * $scale), (8 * $scale), (6 * $scale))
    $g.FillRectangle($wheelBrush, (65 * $scale), (66 * $scale), (8 * $scale), (6 * $scale))

    # Mirrors
    $g.FillEllipse($whiteBrush, (20 * $scale), (48 * $scale), (5 * $scale), (4 * $scale))
    $g.FillEllipse($whiteBrush, (75 * $scale), (48 * $scale), (5 * $scale), (4 * $scale))

    # Headlights (Amber / Orange Glowing LED)
    $headlightLeft = New-Object System.Drawing.RectangleF((26 * $scale), (52 * $scale), (9 * $scale), (5 * $scale))
    $headlightRight = New-Object System.Drawing.RectangleF((65 * $scale), (52 * $scale), (9 * $scale), (5 * $scale))
    $g.FillEllipse($amberBrush, $headlightLeft)
    $g.FillEllipse($amberBrush, $headlightRight)

    # Center Grille
    $grilleRect = New-Object System.Drawing.RectangleF((37 * $scale), (58 * $scale), (26 * $scale), (7 * $scale))
    $g.FillRectangle($darkTealBrush, $grilleRect)
    
    # Grille Hexagon Logo
    $g.FillEllipse($cyanBrush, (48 * $scale), (59.5 * $scale), (4 * $scale), (4 * $scale))

    # 4. Brand Speed Line / Road Indicator
    $roadPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 245, 158, 11), [math]::Max(2.0, $size * 0.04))
    $g.DrawLine($roadPen, [float](35 * $scale), [float](78 * $scale), [float](65 * $scale), [float](78 * $scale))

    # Clean up
    $g.Dispose()
    return $bmp
}

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  GENERATING BRANDED LAUNCHER ICONS FOR ALL DENSITIES" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

foreach ($d in $densities) {
    $dir = Join-Path $resDir $d.Name
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $iconSquare = Draw-CarRentalIcon -size $d.Size -isRound $false
    $iconRound = Draw-CarRentalIcon -size $d.Size -isRound $true

    $squarePath = Join-Path $dir "ic_launcher.png"
    $roundPath = Join-Path $dir "ic_launcher_round.png"

    $iconSquare.Save($squarePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $iconRound.Save($roundPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $iconSquare.Dispose()
    $iconRound.Dispose()

    Write-Host " [CREATED] $($d.Name) ($($d.Size)x$($d.Size) px): ic_launcher.png & ic_launcher_round.png" -ForegroundColor Green
}

# Also generate 512x512 Play Store Hi-Res Icon
$playStoreIcon = Draw-CarRentalIcon -size 512 -isRound $false
$playStorePath = Join-Path $resDir "ic_launcher-playstore.png"
$playStoreIcon.Save($playStorePath, [System.Drawing.Imaging.ImageFormat]::Png)
$playStoreIcon.Dispose()
Write-Host " [CREATED] Play Store High-Res Icon (512x512 px): ic_launcher-playstore.png" -ForegroundColor Green
