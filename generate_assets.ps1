# Generate visual assets and high-res SVG/WebP car representations for Car Rental Dehradun

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$carsDir = Join-Path $scriptDir "images\cars"
$iconsDir = Join-Path $scriptDir "images\icons"

if (-not (Test-Path $carsDir)) { New-Item -ItemType Directory -Path $carsDir -Force }
if (-not (Test-Path $iconsDir)) { New-Item -ItemType Directory -Path $iconsDir -Force }

function Create-CarSvg ($name, $category, $color, $accentColor, $filePath) {
    $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 360" width="100%" height="100%">
  <defs>
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#f8fafc"/>
      <stop offset="100%" stop-color="#e2e8f0"/>
    </linearGradient>
    <linearGradient id="bodyGrad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="$color"/>
      <stop offset="100%" stop-color="$accentColor"/>
    </linearGradient>
    <linearGradient id="glassGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#38bdf8" stop-opacity="0.8"/>
      <stop offset="100%" stop-color="#0284c7" stop-opacity="0.9"/>
    </linearGradient>
    <filter id="carShadow" x="-10%" y="-10%" width="120%" height="130%">
      <feDropShadow dx="0" dy="12" stdDeviation="10" flood-color="#0f172a" flood-opacity="0.25"/>
    </filter>
  </defs>

  <!-- Background Card -->
  <rect width="600" height="360" rx="16" fill="url(#bgGrad)"/>
  
  <!-- Subtle Mountain Silhouette Backdrop -->
  <path d="M 0 240 L 120 180 L 220 220 L 380 140 L 480 200 L 600 160 L 600 360 L 0 360 Z" fill="#cbd5e1" opacity="0.4"/>
  <path d="M 0 260 L 160 210 L 320 250 L 460 190 L 600 230 L 600 360 L 0 360 Z" fill="#94a3b8" opacity="0.3"/>

  <!-- Ground Shadow -->
  <ellipse cx="300" cy="300" rx="230" ry="18" fill="#0f172a" opacity="0.2" filter="blur(6px)"/>

  <!-- Vehicle Silhouette & Body Graphic -->
  <g filter="url(#carShadow)">
    <!-- Main Car Body -->
    <path d="M 90 260 
             C 85 240, 95 210, 130 200 
             L 200 195 
             L 250 135 
             C 270 115, 390 115, 420 135 
             L 470 195 
             L 515 210 
             C 530 225, 535 250, 520 270 
             L 460 270 
             C 455 240, 415 240, 410 270 
             L 210 270 
             C 205 240, 165 240, 160 270 
             Z" 
          fill="url(#bodyGrad)" stroke="#1e293b" stroke-width="2"/>

    <!-- Windows / Windshield -->
    <path d="M 210 190 
             L 255 140 
             C 270 128, 335 128, 335 128 
             L 335 190 
             Z" 
          fill="url(#glassGrad)"/>
    <path d="M 345 128 
             C 345 128, 390 128, 410 140 
             L 455 190 
             L 345 190 
             Z" 
          fill="url(#glassGrad)"/>

    <!-- Door Line & Details -->
    <line x1="340" y1="130" x2="340" y2="265" stroke="#334155" stroke-width="2"/>
    <line x1="260" y1="210" x2="310" y2="210" stroke="#475569" stroke-width="3" stroke-linecap="round"/>
    <line x1="360" y1="210" x2="410" y2="210" stroke="#475569" stroke-width="3" stroke-linecap="round"/>

    <!-- Headlight -->
    <path d="M 505 215 L 525 225 L 505 235 Z" fill="#fef08a" stroke="#eab308" stroke-width="1.5"/>
    
    <!-- Taillight -->
    <path d="M 95 215 L 85 225 L 95 235 Z" fill="#ef4444" stroke="#b91c1c" stroke-width="1.5"/>

    <!-- Front Wheel -->
    <g transform="translate(435, 270)">
      <circle cx="0" cy="0" r="34" fill="#1e293b"/>
      <circle cx="0" cy="0" r="22" fill="#64748b"/>
      <circle cx="0" cy="0" r="10" fill="#cbd5e1"/>
      <line x1="-18" y1="0" x2="18" y2="0" stroke="#1e293b" stroke-width="3"/>
      <line x1="0" y1="-18" x2="0" y2="18" stroke="#1e293b" stroke-width="3"/>
    </g>

    <!-- Rear Wheel -->
    <g transform="translate(185, 270)">
      <circle cx="0" cy="0" r="34" fill="#1e293b"/>
      <circle cx="0" cy="0" r="22" fill="#64748b"/>
      <circle cx="0" cy="0" r="10" fill="#cbd5e1"/>
      <line x1="-18" y1="0" x2="18" y2="0" stroke="#1e293b" stroke-width="3"/>
      <line x1="0" y1="-18" x2="0" y2="18" stroke="#1e293b" stroke-width="3"/>
    </g>
  </g>

  <!-- Watermark / Car Title Overlay -->
  <g transform="translate(30, 45)">
    <text x="0" y="0" font-family="Outfit, sans-serif" font-weight="800" font-size="22" fill="#0f172a">$name</text>
    <text x="0" y="22" font-family="Inter, sans-serif" font-weight="600" font-size="12" fill="#0f766e" letter-spacing="1">$category • CAR RENTAL DEHRADUN</text>
  </g>
</svg>
"@
    [System.IO.File]::WriteAllText($filePath, $svg, [System.Text.Encoding]::UTF8)
}

# Create Vehicle SVGs
Create-CarSvg "Maruti Swift Dzire" "COMPACT SEDAN" "#f8fafc" "#e2e8f0" (Join-Path $carsDir "swift-dzire.webp")
Create-CarSvg "Maruti Swift Dzire" "SIDE PROFILE" "#f8fafc" "#cbd5e1" (Join-Path $carsDir "swift-dzire-side.webp")

Create-CarSvg "Maruti Ertiga" "7-SEATER MUV" "#94a3b8" "#64748b" (Join-Path $carsDir "ertiga.webp")
Create-CarSvg "Maruti Ertiga" "SIDE VIEW" "#94a3b8" "#475569" (Join-Path $carsDir "ertiga-side.webp")

Create-CarSvg "Mahindra Scorpio N" "BIG DADDY SUV" "#064e3b" "#022c22" (Join-Path $carsDir "scorpio-n.webp")
Create-CarSvg "Mahindra Scorpio N" "4X4 PROFILE" "#064e3b" "#0f172a" (Join-Path $carsDir "scorpio-n-side.webp")

Create-CarSvg "Mahindra Thar" "4X4 ADVENTURE SUV" "#dc2626" "#7f1d1d" (Join-Path $carsDir "thar.webp")
Create-CarSvg "Mahindra Thar" "HARD TOP 4X4" "#dc2626" "#450a0a" (Join-Path $carsDir "thar-side.webp")

Create-CarSvg "Kia Sonet" "SMART COMPACT SUV" "#e11d48" "#9f1239" (Join-Path $carsDir "kia-sonet.webp")
Create-CarSvg "Kia Sonet" "AUTOMATIC SUV" "#e11d48" "#881337" (Join-Path $carsDir "kia-sonet-side.webp")

Create-CarSvg "Hyundai Venue" "COMPACT SUV" "#475569" "#1e293b" (Join-Path $carsDir "hyundai-venue.webp")
Create-CarSvg "Hyundai Venue" "TURBO EDITION" "#475569" "#0f172a" (Join-Path $carsDir "hyundai-venue-side.webp")

Create-CarSvg "Maruti Baleno" "PREMIUM HATCHBACK" "#2563eb" "#1e40af" (Join-Path $carsDir "maruti-baleno.webp")
Create-CarSvg "Maruti Baleno" "NEXA BLUE" "#2563eb" "#1d4ed8" (Join-Path $carsDir "maruti-baleno-side.webp")

Create-CarSvg "Toyota Glanza" "AUTOMATIC HATCHBACK" "#d97706" "#b45309" (Join-Path $carsDir "toyota-glanza.webp")
Create-CarSvg "Toyota Glanza" "DUAL TONE" "#d97706" "#92400e" (Join-Path $carsDir "toyota-glanza-side.webp")

Create-CarSvg "Hyundai i20 Manual" "PREMIUM HATCHBACK" "#e2e8f0" "#cbd5e1" (Join-Path $carsDir "hyundai-i20.webp")
Create-CarSvg "Hyundai i20 Manual" "SPORTZ EDITION" "#e2e8f0" "#94a3b8" (Join-Path $carsDir "hyundai-i20-side.webp")

Create-CarSvg "Hyundai i20 Automatic" "IVT AUTOMATIC" "#b91c1c" "#7f1d1d" (Join-Path $carsDir "hyundai-i20-auto.webp")
Create-CarSvg "Hyundai i20 Automatic" "ASTA IVT" "#b91c1c" "#991b1b" (Join-Path $carsDir "hyundai-i20-auto-side.webp")

# Interior Mock Graphics
Create-CarSvg "Premium Cabin Interior" "5-SEATER" "#0f172a" "#1e293b" (Join-Path $carsDir "interior-sedan.webp")
Create-CarSvg "Luxury SUV Interior" "TOUCHSCREEN COCKPIT" "#0f172a" "#1e293b" (Join-Path $carsDir "interior-suv.webp")
Create-CarSvg "Spacious 7-Seater Cabin" "REAR AC VENTS" "#0f172a" "#1e293b" (Join-Path $carsDir "interior-7seater.webp")
Create-CarSvg "Adventure 4x4 Cockpit" "WEATHERPROOF" "#0f172a" "#1e293b" (Join-Path $carsDir "interior-thar.webp")

# Generate PWA App Icons
function Create-PwaIcon ($size, $filePath) {
    $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $size $size" width="$size" height="$size">
  <defs>
    <linearGradient id="iconBg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#042f2e"/>
      <stop offset="50%" stop-color="#0f766e"/>
      <stop offset="100%" stop-color="#115e59"/>
    </linearGradient>
    <filter id="iconGlow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="4" stdDeviation="6" flood-color="#000" flood-opacity="0.3"/>
    </filter>
  </defs>
  <rect width="$size" height="$size" rx="$($size * 0.22)" fill="url(#iconBg)"/>
  <g filter="url(#iconGlow)" transform="translate($($size * 0.15), $($size * 0.18)) scale($($size * 0.007))">
    <!-- Stylized Car Icon -->
    <path d="M 10 65 C 10 50, 20 40, 35 35 L 50 15 C 55 8, 65 5, 75 5 L 125 5 C 135 5, 145 8, 150 15 L 165 35 C 180 40, 190 50, 190 65 L 190 95 C 190 100, 185 105, 180 105 L 175 105 C 170 105, 165 100, 165 95 L 165 85 L 35 85 L 35 95 C 35 100, 30 105, 25 105 L 20 105 C 15 105, 10 100, 10 95 Z" fill="#ffffff"/>
    <circle cx="45" cy="65" r="10" fill="#f59e0b"/>
    <circle cx="155" cy="65" r="10" fill="#f59e0b"/>
    <path d="M 50 35 L 60 18 L 140 18 L 150 35 Z" fill="#38bdf8"/>
  </g>
  <text x="$($size * 0.5)" y="$($size * 0.88)" font-family="Outfit, sans-serif" font-weight="800" font-size="$($size * 0.12)" fill="#ffffff" text-anchor="middle" letter-spacing="1">DEHRADUN</text>
</svg>
"@
    [System.IO.File]::WriteAllText($filePath, $svg, [System.Text.Encoding]::UTF8)
}

Create-PwaIcon 192 (Join-Path $iconsDir "icon-192.png")
Create-PwaIcon 512 (Join-Path $iconsDir "icon-512.png")

Write-Host "All car assets and PWA icons generated successfully!" -ForegroundColor Green
