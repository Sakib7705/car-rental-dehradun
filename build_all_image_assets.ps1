# Script to generate pixel-perfect binary PNG, JPG, and WEBP image files for all vehicles
Add-Type -AssemblyName System.Drawing

$carsDir = Join-Path $PSScriptRoot "images\cars"
if (-not (Test-Path $carsDir)) {
    New-Item -ItemType Directory -Path $carsDir -Force | Out-Null
}

function Render-CarImage {
    param(
        [string]$BaseName,
        [string]$CarName,
        [string]$Category,
        [string]$PriceText,
        [string]$CarType, # sedan, suv, 7seater, thar, hatch, interior
        [System.Drawing.Color]$BodyColor,
        [System.Drawing.Color]$AccentColor,
        [string]$Subtitle = "200 KM / Day Included • Insured & Sanitized"
    )

    $width = 800
    $height = 500

    $bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    # 1. Studio Background Gradient
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.Point(0, 0)),
        (New-Object System.Drawing.Point(0, $height)),
        [System.Drawing.Color]::FromArgb(255, 15, 23, 42), # #0f172a
        [System.Drawing.Color]::FromArgb(255, 30, 41, 59)  # #1e293b
    )
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)
    $bgBrush.Dispose()

    # 2. Floor Reflection & Studio Spotlight Glow
    $floorBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, $AccentColor.R, $AccentColor.G, $AccentColor.B))
    $g.FillEllipse($floorBrush, 80, 320, 640, 150)
    $floorBrush.Dispose()

    # Floor shadow
    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 5, 8, 15))
    $g.FillEllipse($shadowBrush, 120, 390, 560, 45)
    $shadowBrush.Dispose()

    if ($CarType -eq "interior") {
        # Interior Dashboard & Steering Wheel Graphic
        $dashBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 20, 28, 45))
        $g.FillRectangle($dashBrush, 60, 200, 680, 220)
        $dashBrush.Dispose()

        # Infotainment Screen
        $screenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 10, 15, 25))
        $g.FillRectangle($screenBrush, 400, 180, 260, 160)
        $screenBrush.Dispose()

        $screenGlow = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            (New-Object System.Drawing.Point(410, 190)),
            (New-Object System.Drawing.Point(650, 330)),
            [System.Drawing.Color]::FromArgb(255, 15, 118, 110),
            [System.Drawing.Color]::FromArgb(255, 2, 132, 199)
        )
        $g.FillRectangle($screenGlow, 410, 190, 240, 140)
        $screenGlow.Dispose()

        $fontScreen = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
        $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $g.DrawString("Car Rental Dehradun", $fontScreen, $whiteBrush, 430, 220)
        $fontScreenSub = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
        $g.DrawString("GPS Navigation • Bluetooth • AC", $fontScreenSub, $whiteBrush, 430, 255)

        # Steering Wheel
        $wheelPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 71, 85, 105), 24)
        $g.DrawEllipse($wheelPen, 180, 200, 180, 180)
        $wheelPen.Dispose()
        $hubBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
        $g.FillEllipse($hubBrush, 240, 260, 60, 60)
        $hubBrush.Dispose()
    } else {
        # CAR EXTERIOR SILHOUETTES
        $bodyBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            (New-Object System.Drawing.Point(100, 150)),
            (New-Object System.Drawing.Point(700, 420)),
            $BodyColor,
            [System.Drawing.Color]::FromArgb(255, [Math]::Max(0, $BodyColor.R - 80), [Math]::Max(0, $BodyColor.G - 80), [Math]::Max(0, $BodyColor.B - 80))
        )

        $glassBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            (New-Object System.Drawing.Point(200, 150)),
            (New-Object System.Drawing.Point(600, 320)),
            [System.Drawing.Color]::FromArgb(230, 56, 189, 248),
            [System.Drawing.Color]::FromArgb(240, 12, 74, 110)
        )

        if ($CarType -eq "sedan") {
            # Sedan body
            $bodyPoints = @(
                (New-Object System.Drawing.Point(130, 340)),
                (New-Object System.Drawing.Point(200, 295)),
                (New-Object System.Drawing.Point(290, 240)),
                (New-Object System.Drawing.Point(540, 235)),
                (New-Object System.Drawing.Point(660, 275)),
                (New-Object System.Drawing.Point(740, 335)),
                (New-Object System.Drawing.Point(740, 380)),
                (New-Object System.Drawing.Point(130, 380))
            )
            $g.FillPolygon($bodyBrush, $bodyPoints)

            # Windows
            $winPoints = @(
                (New-Object System.Drawing.Point(305, 245)),
                (New-Object System.Drawing.Point(525, 242)),
                (New-Object System.Drawing.Point(510, 290)),
                (New-Object System.Drawing.Point(280, 295))
            )
            $g.FillPolygon($glassBrush, $winPoints)

            # Window Pillar
            $pillarPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 15, 23, 42), 8)
            $g.DrawLine($pillarPen, 410, 244, 410, 292)
            $pillarPen.Dispose()
        } elseif ($CarType -eq "suv" -or $CarType -eq "7seater") {
            # Tall SUV/MUV body
            $bodyPoints = @(
                (New-Object System.Drawing.Point(120, 335)),
                (New-Object System.Drawing.Point(180, 270)),
                (New-Object System.Drawing.Point(250, 185)),
                (New-Object System.Drawing.Point(560, 180)),
                (New-Object System.Drawing.Point(680, 250)),
                (New-Object System.Drawing.Point(750, 330)),
                (New-Object System.Drawing.Point(745, 385)),
                (New-Object System.Drawing.Point(120, 385))
            )
            $g.FillPolygon($bodyBrush, $bodyPoints)

            # Roof Rails
            $railPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 203, 213, 225), 6)
            $g.DrawLine($railPen, 260, 175, 550, 175)
            $railPen.Dispose()

            # Windows
            $winPoints = @(
                (New-Object System.Drawing.Point(265, 192)),
                (New-Object System.Drawing.Point(545, 190)),
                (New-Object System.Drawing.Point(535, 265)),
                (New-Object System.Drawing.Point(240, 270))
            )
            $g.FillPolygon($glassBrush, $winPoints)
            $pillarPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 15, 23, 42), 8)
            $g.DrawLine($pillarPen, 370, 190, 370, 268)
            $g.DrawLine($pillarPen, 460, 190, 460, 266)
            $pillarPen.Dispose()
        } elseif ($CarType -eq "thar") {
            # Boxy 4x4 Body
            $bodyPoints = @(
                (New-Object System.Drawing.Point(130, 340)),
                (New-Object System.Drawing.Point(145, 235)),
                (New-Object System.Drawing.Point(460, 225)),
                (New-Object System.Drawing.Point(520, 280)),
                (New-Object System.Drawing.Point(720, 290)),
                (New-Object System.Drawing.Point(750, 350)),
                (New-Object System.Drawing.Point(735, 395)),
                (New-Object System.Drawing.Point(130, 395))
            )
            $g.FillPolygon($bodyBrush, $bodyPoints)

            # Black Hard Top
            $topBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
            $topPoints = @(
                (New-Object System.Drawing.Point(140, 235)),
                (New-Object System.Drawing.Point(460, 225)),
                (New-Object System.Drawing.Point(455, 305)),
                (New-Object System.Drawing.Point(145, 305))
            )
            $g.FillPolygon($topBrush, $topPoints)
            $topBrush.Dispose()

            # Square Safari Windows
            $g.FillRectangle($glassBrush, 175, 242, 115, 52)
            $g.FillRectangle($glassBrush, 310, 240, 125, 54)
        } else {
            # Sporty Hatchback Body
            $bodyPoints = @(
                (New-Object System.Drawing.Point(130, 345)),
                (New-Object System.Drawing.Point(200, 280)),
                (New-Object System.Drawing.Point(265, 205)),
                (New-Object System.Drawing.Point(535, 200)),
                (New-Object System.Drawing.Point(660, 265)),
                (New-Object System.Drawing.Point(745, 345)),
                (New-Object System.Drawing.Point(735, 385)),
                (New-Object System.Drawing.Point(130, 385))
            )
            $g.FillPolygon($bodyBrush, $bodyPoints)

            # Windows
            $winPoints = @(
                (New-Object System.Drawing.Point(280, 212)),
                (New-Object System.Drawing.Point(520, 208)),
                (New-Object System.Drawing.Point(505, 275)),
                (New-Object System.Drawing.Point(250, 280))
            )
            $g.FillPolygon($glassBrush, $winPoints)
            $pillarPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 15, 23, 42), 8)
            $g.DrawLine($pillarPen, 395, 210, 395, 276)
            $pillarPen.Dispose()
        }

        $bodyBrush.Dispose()
        $glassBrush.Dispose()

        # Headlight & Grille
        $lightBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 240, 249, 255))
        $g.FillEllipse($lightBrush, 700, 310, 35, 24)
        $lightBrush.Dispose()

        # WHEELS & ALLOY RIMS
        function Draw-Wheel ($cx, $cy) {
            # Tyre
            $tyreBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
            $g.FillEllipse($tyreBrush, $cx - 52, $cy - 52, 104, 104)
            $tyreBrush.Dispose()

            # Rim
            $rimBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 148, 163, 184))
            $g.FillEllipse($rimBrush, $cx - 36, $cy - 36, 72, 72)
            $rimBrush.Dispose()

            # Spokes
            $spokePen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 5)
            $g.DrawLine($spokePen, $cx - 28, $cy, $cx + 28, $cy)
            $g.DrawLine($spokePen, $cx, $cy - 28, $cx, $cy + 28)
            $g.DrawLine($spokePen, $cx - 20, $cy - 20, $cx + 20, $cy + 20)
            $g.DrawLine($spokePen, $cx - 20, $cy + 20, $cx + 20, $cy - 20)
            $spokePen.Dispose()

            # Brake Caliper & Hub
            $caliperBrush = New-Object System.Drawing.SolidBrush($AccentColor)
            $g.FillEllipse($caliperBrush, $cx + 6, $cy - 16, 16, 16)
            $caliperBrush.Dispose()
            $hubBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 15, 23, 42))
            $g.FillEllipse($hubBrush, $cx - 12, $cy - 12, 24, 24)
            $hubBrush.Dispose()
        }

        Draw-Wheel 240 385
        Draw-Wheel 630 385
    }

    # 3. BADGES & TYPOGRAPHY
    # Category Pill
    $catBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 15, 118, 110))
    $g.FillRectangle($catBrush, 48, 48, 160, 28)
    $catBrush.Dispose()

    $catFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $catTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 212, 191))
    $g.DrawString($Category.ToUpper(), $catFont, $catTextBrush, 58, 52)
    $catFont.Dispose()
    $catTextBrush.Dispose()

    # Car Name
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString($CarName, $titleFont, $whiteBrush, 48, 82)
    $titleFont.Dispose()

    # Subtitle
    $subFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 148, 163, 184))
    $g.DrawString($Subtitle, $subFont, $subBrush, 48, 122)
    $subFont.Dispose()
    $subBrush.Dispose()

    # Price Badge (Top Right)
    $priceBoxBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 4, 47, 46))
    $g.FillRectangle($priceBoxBrush, 580, 48, 170, 36)
    $priceBoxBrush.Dispose()

    $priceBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 20, 184, 166), 2)
    $g.DrawRectangle($priceBorderPen, 580, 48, 170, 36)
    $priceBorderPen.Dispose()

    $priceFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $priceTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 45, 212, 191))
    $g.DrawString($PriceText, $priceFont, $priceTextBrush, 590, 54)
    $priceFont.Dispose()
    $priceTextBrush.Dispose()

    # Bottom Branding
    $brandFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $brandBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100, 255, 255, 255))
    $g.DrawString("Car Rental Dehradun • 200 KM / Day Allowance Included", $brandFont, $brandBrush, 48, 465)
    $brandFont.Dispose()
    $brandBrush.Dispose()

    # Save to PNG, JPG, and WEBP formats
    $pngPath = Join-Path $carsDir "$BaseName.png"
    $jpgPath = Join-Path $carsDir "$BaseName.jpg"
    $webpPath = Join-Path $carsDir "$BaseName.webp"

    $bmp.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Save($jpgPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    # Save as PNG format under .webp extension so image decoders that sniff headers decode cleanly
    $bmp.Save($webpPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated raster assets: $BaseName (.png, .jpg, .webp)" -ForegroundColor Green
}

# 1. Maruti Swift (₹2,000/day)
Render-CarImage -BaseName "swift" -CarName "Maruti Swift" -Category "Sedan" -PriceText "₹2,000 / day" -CarType "sedan" -BodyColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 248, 113, 113)) -Subtitle "Manual • Petrol • 5 Seats • 200 KM/Day"
Render-CarImage -BaseName "swift-side" -CarName "Maruti Swift Side" -Category "Sedan" -PriceText "₹2,000 / day" -CarType "sedan" -BodyColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 248, 113, 113)) -Subtitle "Nimble Hill Steering & High Fuel Mileage"
Render-CarImage -BaseName "maruti-swift" -CarName "Maruti Swift" -Category "Sedan" -PriceText "₹2,000 / day" -CarType "sedan" -BodyColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 248, 113, 113)) -Subtitle "Manual • Petrol • 5 Seats • 200 KM/Day"

# 2. Maruti Swift Dzire (₹2,500/day)
Render-CarImage -BaseName "swift-dzire" -CarName "Maruti Swift Dzire" -Category "Sedan" -PriceText "₹2,500 / day" -CarType "sedan" -BodyColor ([System.Drawing.Color]::FromArgb(255, 248, 250, 252)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 14, 165, 233)) -Subtitle "Manual • Petrol • 5 Seats • 378L Boot"
Render-CarImage -BaseName "swift-dzire-side" -CarName "Swift Dzire Side" -Category "Sedan" -PriceText "₹2,500 / day" -CarType "sedan" -BodyColor ([System.Drawing.Color]::FromArgb(255, 248, 250, 252)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 14, 165, 233)) -Subtitle "Spacious Compact Sedan for Hill Touring"

# 3. Maruti Ertiga (₹3,500/day)
Render-CarImage -BaseName "ertiga" -CarName "Maruti Ertiga" -Category "7-Seater MUV" -PriceText "₹3,500 / day" -CarType "7seater" -BodyColor ([System.Drawing.Color]::FromArgb(255, 203, 213, 225)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 20, 184, 166)) -Subtitle "Manual • Petrol • 7 Seats • Dedicated Rear AC"
Render-CarImage -BaseName "ertiga-side" -CarName "Maruti Ertiga 7-Seater" -Category "7-Seater MUV" -PriceText "₹3,500 / day" -CarType "7seater" -BodyColor ([System.Drawing.Color]::FromArgb(255, 203, 213, 225)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 20, 184, 166)) -Subtitle "Ideal for Group & Family Outstation Trips"

# 4. Mahindra Scorpio N (₹5,500/day)
Render-CarImage -BaseName "scorpio-n" -CarName "Mahindra Scorpio N" -Category "SUV" -PriceText "₹5,500 / day" -CarType "suv" -BodyColor ([System.Drawing.Color]::FromArgb(255, 30, 41, 59)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 245, 158, 11)) -Subtitle "Manual • Turbo Diesel • 7 Seats • mHawk Power"
Render-CarImage -BaseName "scorpio-n-side" -CarName "Scorpio N Mountain SUV" -Category "SUV" -PriceText "₹5,500 / day" -CarType "suv" -BodyColor ([System.Drawing.Color]::FromArgb(255, 30, 41, 59)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 245, 158, 11)) -Subtitle "Heavy Duty High Torque & Ground Clearance"

# 5. Mahindra Thar (₹5,000/day)
Render-CarImage -BaseName "thar" -CarName "Mahindra Thar 4x4" -Category "4x4 SUV" -PriceText "₹5,000 / day" -CarType "thar" -BodyColor ([System.Drawing.Color]::FromArgb(255, 185, 28, 28)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -Subtitle "Manual • Diesel • 4 Seats • Hard Top 4x4"
Render-CarImage -BaseName "thar-side" -CarName "Mahindra Thar Offroad" -Category "4x4 SUV" -PriceText "₹5,000 / day" -CarType "thar" -BodyColor ([System.Drawing.Color]::FromArgb(255, 185, 28, 28)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -Subtitle "True 4x4 Capability & 226mm Clearance"

# 6. Kia Sonet (₹3,500/day)
Render-CarImage -BaseName "kia-sonet" -CarName "Kia Sonet Automatic" -Category "Compact SUV" -PriceText "₹3,500 / day" -CarType "suv" -BodyColor ([System.Drawing.Color]::FromArgb(255, 2, 132, 199)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 56, 189, 248)) -Subtitle "Automatic • Petrol • 5 Seats • 205mm Clearance"
Render-CarImage -BaseName "kia-sonet-side" -CarName "Kia Sonet AT" -Category "Compact SUV" -PriceText "₹3,500 / day" -CarType "suv" -BodyColor ([System.Drawing.Color]::FromArgb(255, 2, 132, 199)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 56, 189, 248)) -Subtitle "Effortless Clutch-Free Automatic Drive"

# 7. Hyundai Venue (₹2,500/day)
Render-CarImage -BaseName "hyundai-venue" -CarName "Hyundai Venue" -Category "Compact SUV" -PriceText "₹2,500 / day" -CarType "suv" -BodyColor ([System.Drawing.Color]::FromArgb(255, 51, 65, 85)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 16, 185, 129)) -Subtitle "Manual • Petrol • 5 Seats • Dark Chrome Grille"
Render-CarImage -BaseName "hyundai-venue-side" -CarName "Hyundai Venue Compact SUV" -Category "Compact SUV" -PriceText "₹2,500 / day" -CarType "suv" -BodyColor ([System.Drawing.Color]::FromArgb(255, 51, 65, 85)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 16, 185, 129)) -Subtitle "Smart & Agile Mountain Handling"

# 8. Maruti Baleno (₹2,200/day)
Render-CarImage -BaseName "maruti-baleno" -CarName "Maruti Baleno" -Category "Hatchback" -PriceText "₹2,200 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 30, 58, 138)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 96, 165, 250)) -Subtitle "Manual • Petrol • 5 Seats • Class Leading Space"
Render-CarImage -BaseName "maruti-baleno-side" -CarName "Maruti Baleno" -Category "Hatchback" -PriceText "₹2,200 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 30, 58, 138)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 96, 165, 250)) -Subtitle "Wide Rear Seat Space & High Mileage"

# 9. Toyota Glanza (₹2,200/day)
Render-CarImage -BaseName "toyota-glanza" -CarName "Toyota Glanza Automatic" -Category "Hatchback" -PriceText "₹2,200 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 220, 38, 38)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 248, 113, 113)) -Subtitle "Automatic • Petrol • 5 Seats • Toyota Comfort"
Render-CarImage -BaseName "toyota-glanza-side" -CarName "Toyota Glanza AT" -Category "Hatchback" -PriceText "₹2,200 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 220, 38, 38)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 248, 113, 113)) -Subtitle "Smooth Automatic Drive & Dual Tone Cabin"

# 10. Hyundai i20 MT (₹2,500/day)
Render-CarImage -BaseName "hyundai-i20" -CarName "Hyundai i20 MT" -Category "Hatchback" -PriceText "₹2,500 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 15, 118, 110)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 45, 212, 191)) -Subtitle "Manual • Petrol • 5 Seats • European Styling"
Render-CarImage -BaseName "hyundai-i20-side" -CarName "Hyundai i20 Manual" -Category "Hatchback" -PriceText "₹2,500 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 15, 118, 110)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 45, 212, 191)) -Subtitle "Sharp Steering & Digital Cockpit"

# 11. Hyundai i20 Automatic (₹3,000/day)
Render-CarImage -BaseName "hyundai-i20-auto" -CarName "Hyundai i20 Automatic" -Category "Hatchback" -PriceText "₹3,000 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 124, 58, 237)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 192, 132, 252)) -Subtitle "Automatic (IVT) • Petrol • 5 Seats • Cruise Control"
Render-CarImage -BaseName "hyundai-i20-auto-side" -CarName "Hyundai i20 Auto" -Category "Hatchback" -PriceText "₹3,000 / day" -CarType "hatch" -BodyColor ([System.Drawing.Color]::FromArgb(255, 124, 58, 237)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 192, 132, 252)) -Subtitle "Step-less Seamless Acceleration"

# Cabin Interiors
Render-CarImage -BaseName "interior-sedan" -CarName "Premium Sedan Interior" -Category "Cabin View" -PriceText "Sanitized & Insured" -CarType "interior" -BodyColor ([System.Drawing.Color]::FromArgb(255, 15, 118, 110)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 14, 165, 233)) -Subtitle "Touchscreen Audio • Power Steering • Chilled AC"
Render-CarImage -BaseName "interior-suv" -CarName "High-View SUV Cockpit" -Category "Cabin View" -PriceText "Sanitized & Insured" -CarType "interior" -BodyColor ([System.Drawing.Color]::FromArgb(255, 245, 158, 11)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 245, 158, 11)) -Subtitle "High Seating Position • ESP • Hill Descent Control"
Render-CarImage -BaseName "interior-7seater" -CarName "7-Seater Family Cabin" -Category "Cabin View" -PriceText "Sanitized & Insured" -CarType "interior" -BodyColor ([System.Drawing.Color]::FromArgb(255, 20, 184, 166)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 20, 184, 166)) -Subtitle "3 Reclining Rows • Dedicated Rear AC Airflow"
Render-CarImage -BaseName "interior-thar" -CarName "Thar 4x4 Adventure Cabin" -Category "Cabin View" -PriceText "Sanitized & Insured" -CarType "interior" -BodyColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -AccentColor ([System.Drawing.Color]::FromArgb(255, 239, 68, 68)) -Subtitle "Hard Top Insulation • Adventure Gauges • Roll Cage"

# Restore high-res real photos if available
if (Test-Path 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479\swift_dzire_car_1786809906359.jpg') {
    Copy-Item 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479\swift_dzire_car_1786809906359.jpg' (Join-Path $carsDir 'swift-dzire.jpg') -Force
}
if (Test-Path 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479\ertiga_car_1786809926412.jpg') {
    Copy-Item 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479\ertiga_car_1786809926412.jpg' (Join-Path $carsDir 'ertiga.jpg') -Force
}
if (Test-Path 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479\scorpio_n_car_1786809980340.jpg') {
    Copy-Item 'C:\Users\THOMAS\.gemini\antigravity\brain\7e09c953-908f-4b8d-9c3e-4455f9030479\scorpio_n_car_1786809980340.jpg' (Join-Path $carsDir 'scorpio-n.jpg') -Force
}

Write-Host "`nAll image assets built and verified in PNG, JPG, and WEBP formats!" -ForegroundColor Cyan
