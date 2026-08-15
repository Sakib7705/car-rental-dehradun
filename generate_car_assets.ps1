# Automated Vector & Graphic Asset Builder for All 10 Fleet Vehicles

$carsDir = Join-Path $PSScriptRoot "images\cars"
if (-not (Test-Path $carsDir)) {
    New-Item -ItemType Directory -Path $carsDir -Force | Out-Null
}

function Create-CarSvg {
    param(
        [string]$FileName,
        [string]$CarName,
        [string]$Category,
        [string]$BodyColor1,
        [string]$BodyColor2,
        [string]$AccentColor,
        [string]$CarType, # sedan, suv, 7seater, thar, hatch
        [string]$Subtext = ""
    )

    $svgContent = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="100%" height="100%">
  <defs>
    <!-- Background Studio Gradient -->
    <linearGradient id="bgGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#0f172a"/>
      <stop offset="60%" stop-color="#1e293b"/>
      <stop offset="100%" stop-color="#0f172a"/>
    </linearGradient>

    <!-- Floor Reflection Gradient -->
    <radialGradient id="floorGlow" cx="50%" cy="80%" r="50%">
      <stop offset="0%" stop-color="$AccentColor" stop-opacity="0.25"/>
      <stop offset="60%" stop-color="#0f766e" stop-opacity="0.08"/>
      <stop offset="100%" stop-color="#0f172a" stop-opacity="0"/>
    </radialGradient>

    <!-- Body Gradient -->
    <linearGradient id="carBodyGrad" x1="0%" y1="20%" x2="100%" y2="80%">
      <stop offset="0%" stop-color="$BodyColor1"/>
      <stop offset="50%" stop-color="$BodyColor2"/>
      <stop offset="100%" stop-color="#0f172a"/>
    </linearGradient>

    <!-- Glass Gradient -->
    <linearGradient id="glassGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#38bdf8" stop-opacity="0.6"/>
      <stop offset="50%" stop-color="#0284c7" stop-opacity="0.8"/>
      <stop offset="100%" stop-color="#0c4a6e" stop-opacity="0.95"/>
    </linearGradient>

    <!-- Metallic Trim Gradient -->
    <linearGradient id="metalGrad" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" stop-color="#e2e8f0"/>
      <stop offset="50%" stop-color="#ffffff"/>
      <stop offset="100%" stop-color="#94a3b8"/>
    </linearGradient>

    <!-- Wheel Rim Gradient -->
    <radialGradient id="rimGrad" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#ffffff"/>
      <stop offset="40%" stop-color="#94a3b8"/>
      <stop offset="80%" stop-color="#334155"/>
      <stop offset="100%" stop-color="#0f172a"/>
    </radialGradient>

    <!-- Tyre Gradient -->
    <radialGradient id="tyreGrad" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#334155"/>
      <stop offset="70%" stop-color="#1e293b"/>
      <stop offset="100%" stop-color="#090d16"/>
    </radialGradient>

    <!-- Drop Shadow Filter -->
    <filter id="carDropShadow" x="-20%" y="-20%" width="140%" height="150%">
      <feDropShadow dx="0" dy="18" stdDeviation="16" flood-color="#000000" flood-opacity="0.6"/>
    </filter>

    <filter id="headlightGlow" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="8" result="blur"/>
      <feComposite in="SourceGraphic" in2="blur" operator="over"/>
    </filter>
  </defs>

  <!-- Background -->
  <rect width="100%" height="100%" fill="url(#bgGrad)"/>
  
  <!-- Floor Grid & Reflection -->
  <ellipse cx="400" cy="400" rx="360" ry="80" fill="url(#floorGlow)"/>
  <ellipse cx="400" cy="415" rx="340" ry="25" fill="#000000" opacity="0.6" filter="blur(8px)"/>

  <!-- Geometric Grid Overlay -->
  <g opacity="0.07" stroke="#ffffff" stroke-width="1">
    <line x1="100" y1="400" x2="700" y2="400"/>
    <line x1="140" y1="420" x2="660" y2="420"/>
    <line x1="200" y1="440" x2="600" y2="440"/>
  </g>

  <!-- CAR SILHOUETTE & BODYWORK -->
  <g filter="url(#carDropShadow)">
"@

    if ($CarType -eq "sedan") {
        $svgContent += @"
    <!-- Sedan Body (Swift Dzire) -->
    <!-- Main Shell -->
    <path d="M 120 340 C 130 310, 160 300, 200 295 L 280 250 C 330 200, 480 195, 560 240 L 670 275 C 720 285, 750 310, 760 345 C 760 375, 730 380, 710 380 L 160 380 C 130 380, 115 365, 120 340 Z" fill="url(#carBodyGrad)" stroke="#475569" stroke-width="1"/>
    <!-- Greenhouse / Cabin Roof -->
    <path d="M 295 248 C 340 205, 470 200, 545 242 L 530 285 L 275 290 Z" fill="url(#glassGrad)" stroke="#0f172a" stroke-width="2"/>
    <!-- Window Pillar Separator -->
    <line x1="410" y1="205" x2="410" y2="288" stroke="#1e293b" stroke-width="8"/>
    <!-- Front Windshield Highlight -->
    <path d="M 545 242 L 530 285 L 485 285 L 495 210 Z" fill="#ffffff" opacity="0.2"/>
    <!-- Character Lines -->
    <path d="M 140 330 Q 400 320 740 335" stroke="#ffffff" stroke-width="2" opacity="0.4" fill="none"/>
    <path d="M 190 305 Q 400 295 680 305" stroke="#000000" stroke-width="2" opacity="0.4" fill="none"/>
    <!-- Headlight -->
    <polygon points="710,310 755,335 725,350 690,330" fill="#f8fafc" filter="url(#headlightGlow)"/>
    <polygon points="720,318 750,335 730,345 700,330" fill="#38bdf8"/>
    <!-- Front Grille -->
    <path d="M 740 340 L 760 350 L 755 375 L 725 375 Z" fill="#0f172a" stroke="url(#metalGrad)" stroke-width="2"/>
"@
    } elseif ($CarType -eq "suv" -or $CarType -eq "7seater") {
        $svgContent += @"
    <!-- Tall SUV / MUV Body (Scorpio N / Ertiga / Sonet / Venue) -->
    <path d="M 110 340 C 120 290, 150 280, 190 275 L 250 190 C 290 170, 520 170, 580 220 L 690 255 C 735 270, 770 295, 775 345 C 775 385, 740 390, 710 390 L 150 390 C 120 390, 105 370, 110 340 Z" fill="url(#carBodyGrad)" stroke="#475569" stroke-width="1.5"/>
    <!-- Roof Rails -->
    <path d="M 270 175 L 560 175" stroke="url(#metalGrad)" stroke-width="6" stroke-linecap="round"/>
    <line x1="300" y1="175" x2="300" y2="185" stroke="#94a3b8" stroke-width="4"/>
    <line x1="530" y1="175" x2="530" y2="185" stroke="#94a3b8" stroke-width="4"/>
    <!-- Tall Greenhouse Windows -->
    <path d="M 265 192 C 300 175, 510 175, 565 220 L 550 270 L 240 275 Z" fill="url(#glassGrad)" stroke="#0f172a" stroke-width="2"/>
    <!-- Window Pillars (A, B, C Pillars) -->
    <line x1="370" y1="180" x2="370" y2="272" stroke="#1e293b" stroke-width="9"/>
    <line x1="470" y1="180" x2="470" y2="272" stroke="#1e293b" stroke-width="8"/>
    <!-- High Ground Clearance Cladding -->
    <path d="M 115 365 L 770 365 L 765 390 L 120 390 Z" fill="#090d16"/>
    <!-- High Stance Headlight -->
    <polygon points="720,285 768,310 740,335 700,310" fill="#f8fafc" filter="url(#headlightGlow)"/>
    <polygon points="730,295 760,312 742,328 712,312" fill="#38bdf8"/>
    <!-- Bold Chrome Grille Slats -->
    <path d="M 750 315 L 775 325 L 770 365 L 735 365 Z" fill="#0f172a" stroke="url(#metalGrad)" stroke-width="3"/>
"@
    } elseif ($CarType -eq "thar") {
        $svgContent += @"
    <!-- Rugged Boxy 4x4 Body (Mahindra Thar) -->
    <!-- Hardtop Box Cabin -->
    <path d="M 120 340 L 140 240 L 460 230 L 520 280 L 730 295 L 760 350 L 740 395 L 130 395 Z" fill="url(#carBodyGrad)" stroke="#334155" stroke-width="2"/>
    <!-- Matte Black Hard Top Roof -->
    <path d="M 135 240 L 465 230 L 460 305 L 145 305 Z" fill="#090d16" stroke="#1e293b" stroke-width="2"/>
    <!-- Safari Square Windows -->
    <rect x="170" y="245" width="120" height="50" rx="4" fill="url(#glassGrad)"/>
    <rect x="310" y="245" width="130" height="50" rx="4" fill="url(#glassGrad)"/>
    <!-- Front Windshield -->
    <polygon points="465,232 518,280 475,285 460,240" fill="url(#glassGrad)"/>
    <!-- Exposed Door Hinges & Offroad Bolts -->
    <circle cx="305" cy="325" r="4" fill="#94a3b8"/>
    <circle cx="305" cy="365" r="4" fill="#94a3b8"/>
    <!-- Extreme Offroad Wheel Arches -->
    <path d="M 180 395 C 180 320, 300 320, 300 395 Z" fill="#090d16"/>
    <path d="M 570 395 C 570 320, 690 320, 690 395 Z" fill="#090d16"/>
    <!-- Round Signature 4x4 Headlamp -->
    <circle cx="730" cy="325" r="22" fill="#0f172a" stroke="url(#metalGrad)" stroke-width="3"/>
    <circle cx="730" cy="325" r="16" fill="#fef08a" filter="url(#headlightGlow)"/>
    <!-- Heavy Duty Metal Bumper -->
    <rect x="720" y="365" width="55" height="30" rx="4" fill="#1e293b" stroke="#475569" stroke-width="2"/>
"@
    } else {
        $svgContent += @"
    <!-- Sporty Hatchback Body (Baleno / Glanza / i20) -->
    <path d="M 125 345 C 135 305, 170 290, 210 280 L 260 215 C 310 185, 490 185, 550 235 L 670 270 C 720 285, 755 315, 760 350 C 760 380, 730 385, 700 385 L 160 385 C 130 385, 118 370, 125 345 Z" fill="url(#carBodyGrad)" stroke="#475569" stroke-width="1"/>
    <!-- Aerodynamic Hatch Glass -->
    <path d="M 275 218 C 320 190, 480 190, 535 238 L 520 282 L 250 282 Z" fill="url(#glassGrad)" stroke="#0f172a" stroke-width="2"/>
    <line x1="395" y1="195" x2="395" y2="280" stroke="#1e293b" stroke-width="8"/>
    <!-- Sleek Swept-Back LED Headlamp -->
    <polygon points="700,295 752,320 720,340 680,320" fill="#f8fafc" filter="url(#headlightGlow)"/>
    <polygon points="710,305 745,322 725,335 690,322" fill="#38bdf8"/>
    <!-- Cascading Sport Grille -->
    <path d="M 735 325 L 758 335 L 750 370 L 720 370 Z" fill="#0f172a" stroke="url(#metalGrad)" stroke-width="2"/>
"@
    }

    $svgContent += @"
    <!-- WHEELS & ALLOY RIMS -->
    <!-- Rear Wheel -->
    <g transform="translate(240, 385)">
      <circle cx="0" cy="0" r="55" fill="url(#tyreGrad)" stroke="#000000" stroke-width="4"/>
      <circle cx="0" cy="0" r="38" fill="url(#rimGrad)" stroke="#475569" stroke-width="3"/>
      <!-- Alloy Spokes -->
      <line x1="-30" y1="0" x2="30" y2="0" stroke="url(#metalGrad)" stroke-width="6"/>
      <line x1="0" y1="-30" x2="0" y2="30" stroke="url(#metalGrad)" stroke-width="6"/>
      <line x1="-22" y1="-22" x2="22" y2="22" stroke="url(#metalGrad)" stroke-width="6"/>
      <line x1="-22" y1="22" x2="22" y2="-22" stroke="url(#metalGrad)" stroke-width="6"/>
      <!-- Center Hub & Brake Caliper -->
      <circle cx="10" cy="-10" r="14" fill="$AccentColor" opacity="0.9"/>
      <circle cx="0" cy="0" r="12" fill="#0f172a" stroke="#ffffff" stroke-width="2"/>
    </g>

    <!-- Front Wheel -->
    <g transform="translate(630, 385)">
      <circle cx="0" cy="0" r="55" fill="url(#tyreGrad)" stroke="#000000" stroke-width="4"/>
      <circle cx="0" cy="0" r="38" fill="url(#rimGrad)" stroke="#475569" stroke-width="3"/>
      <!-- Alloy Spokes -->
      <line x1="-30" y1="0" x2="30" y2="0" stroke="url(#metalGrad)" stroke-width="6"/>
      <line x1="0" y1="-30" x2="0" y2="30" stroke="url(#metalGrad)" stroke-width="6"/>
      <line x1="-22" y1="-22" x2="22" y2="22" stroke="url(#metalGrad)" stroke-width="6"/>
      <line x1="-22" y1="22" x2="22" y2="-22" stroke="url(#metalGrad)" stroke-width="6"/>
      <!-- Center Hub & Brake Caliper -->
      <circle cx="10" cy="-10" r="14" fill="$AccentColor" opacity="0.9"/>
      <circle cx="0" cy="0" r="12" fill="#0f172a" stroke="#ffffff" stroke-width="2"/>
    </g>
  </g>

  <!-- BADGES & TYPOGRAPHY OVERLAY -->
  <g transform="translate(50, 55)">
    <!-- Category Pill -->
    <rect x="0" y="0" width="160" height="28" rx="14" fill="$AccentColor" fill-opacity="0.2" stroke="$AccentColor" stroke-width="1.5"/>
    <text x="80" y="19" fill="#ffffff" font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="12" font-weight="700" text-anchor="middle" letter-spacing="1">$Category</text>

    <!-- Car Name -->
    <text x="0" y="65" fill="#ffffff" font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="28" font-weight="800" letter-spacing="0.5">$CarName</text>
    
    <!-- Subtext -->
    <text x="0" y="90" fill="#94a3b8" font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="13" font-weight="500">$Subtext</text>
  </g>

  <!-- 200 KM / Day Allowance Badge (Top Right) -->
  <g transform="translate(600, 55)">
    <rect x="0" y="0" width="150" height="32" rx="16" fill="#042f2e" stroke="#14b8a6" stroke-width="1.5"/>
    <text x="75" y="21" fill="#2dd4bf" font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="12" font-weight="700" text-anchor="middle">🚀 200 KM / Day</text>
  </g>

  <!-- Watermark Logo (Bottom Right) -->
  <text x="750" y="475" fill="#ffffff" opacity="0.3" font-family="-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" font-size="11" font-weight="600" text-anchor="end">Car Rental Dehradun • Self Drive Fleet</text>
</svg>
"@

    $targetPath = Join-Path $carsDir $FileName
    [System.IO.File]::WriteAllText($targetPath, $svgContent, [System.Text.Encoding]::UTF8)
    Write-Host "Created: images/cars/$FileName" -ForegroundColor Green
}

# 0. Maruti Swift
Create-CarSvg -FileName "swift.svg" -CarName "Maruti Swift" -Category "SEDAN" -BodyColor1 "#ef4444" -BodyColor2 "#b91c1c" -AccentColor "#f87171" -CarType "sedan" -Subtext "Manual • Petrol • 5 Seats • ₹2,000/day"
Create-CarSvg -FileName "swift-side.svg" -CarName "Maruti Swift Side" -Category "SEDAN" -BodyColor1 "#ef4444" -BodyColor2 "#b91c1c" -AccentColor "#f87171" -CarType "sedan" -Subtext "Nimble Hill Steering & High Fuel Mileage"
Create-CarSvg -FileName "maruti-swift.svg" -CarName "Maruti Swift" -Category "SEDAN" -BodyColor1 "#ef4444" -BodyColor2 "#b91c1c" -AccentColor "#f87171" -CarType "sedan" -Subtext "Manual • Petrol • 5 Seats • ₹2,000/day"

# 1. Maruti Swift Dzire
Create-CarSvg -FileName "swift-dzire.svg" -CarName "Maruti Swift Dzire" -Category "SEDAN" -BodyColor1 "#f8fafc" -BodyColor2 "#cbd5e1" -AccentColor "#0ea5e9" -CarType "sedan" -Subtext "Manual • Petrol • 5 Seats • 200 KM/Day"
Create-CarSvg -FileName "swift-dzire-side.svg" -CarName "Swift Dzire Side Profile" -Category "SEDAN" -BodyColor1 "#f8fafc" -BodyColor2 "#cbd5e1" -AccentColor "#0ea5e9" -CarType "sedan" -Subtext "Spacious 378L Boot • Great Fuel Economy"

# 2. Maruti Ertiga
Create-CarSvg -FileName "ertiga.svg" -CarName "Maruti Ertiga" -Category "7-SEATER MUV" -BodyColor1 "#e2e8f0" -BodyColor2 "#94a3b8" -AccentColor "#14b8a6" -CarType "7seater" -Subtext "Manual • Petrol • 7 Seats • Rear AC"
Create-CarSvg -FileName "ertiga-side.svg" -CarName "Maruti Ertiga 7-Seater" -Category "7-SEATER MUV" -BodyColor1 "#e2e8f0" -BodyColor2 "#94a3b8" -AccentColor "#14b8a6" -CarType "7seater" -Subtext "Ideal for Group & Family Mountain Trips"

# 3. Mahindra Scorpio N
Create-CarSvg -FileName "scorpio-n.svg" -CarName "Mahindra Scorpio N" -Category "SUV" -BodyColor1 "#1e293b" -BodyColor2 "#0f172a" -AccentColor "#f59e0b" -CarType "suv" -Subtext "Manual • Turbo Diesel • 7 Seats • mHawk Power"
Create-CarSvg -FileName "scorpio-n-side.svg" -CarName "Scorpio N Mountain SUV" -Category "SUV" -BodyColor1 "#1e293b" -BodyColor2 "#0f172a" -AccentColor "#f59e0b" -CarType "suv" -Subtext "Heavy Duty High Torque & Ground Clearance"

# 4. Mahindra Thar
Create-CarSvg -FileName "thar.svg" -CarName "Mahindra Thar 4x4" -Category "4x4 SUV" -BodyColor1 "#b91c1c" -BodyColor2 "#7f1d1d" -AccentColor "#ef4444" -CarType "thar" -Subtext "Manual • Diesel • 4x4 Off-Road • Hard Top"
Create-CarSvg -FileName "thar-side.svg" -CarName "Mahindra Thar Offroad" -Category "4x4 SUV" -BodyColor1 "#b91c1c" -BodyColor2 "#7f1d1d" -AccentColor "#ef4444" -CarType "thar" -Subtext "True 4x4 Capability & High Clearance"

# 5. Kia Sonet
Create-CarSvg -FileName "kia-sonet.svg" -CarName "Kia Sonet Automatic" -Category "COMPACT SUV" -BodyColor1 "#0284c7" -BodyColor2 "#0369a1" -AccentColor "#38bdf8" -CarType "suv" -Subtext "Automatic • Petrol • 5 Seats • 205mm Clearance"
Create-CarSvg -FileName "kia-sonet-side.svg" -CarName "Kia Sonet AT" -Category "COMPACT SUV" -BodyColor1 "#0284c7" -BodyColor2 "#0369a1" -AccentColor "#38bdf8" -CarType "suv" -Subtext "Effortless Clutch-Free Automatic Drive"

# 6. Hyundai Venue
Create-CarSvg -FileName "hyundai-venue.svg" -CarName "Hyundai Venue" -Category "COMPACT SUV" -BodyColor1 "#334155" -BodyColor2 "#1e293b" -AccentColor "#10b981" -CarType "suv" -Subtext "Manual • Petrol • 5 Seats • Dark Chrome Grille"
Create-CarSvg -FileName "hyundai-venue-side.svg" -CarName "Hyundai Venue Compact SUV" -Category "COMPACT SUV" -BodyColor1 "#334155" -BodyColor2 "#1e293b" -AccentColor "#10b981" -CarType "suv" -Subtext "Smart & Agile Mountain Handling"

# 7. Maruti Baleno
Create-CarSvg -FileName "maruti-baleno.svg" -CarName "Maruti Baleno" -Category "HATCHBACK" -BodyColor1 "#1e3a8a" -BodyColor2 "#172554" -AccentColor "#60a5fa" -CarType "hatch" -Subtext "Manual • Petrol • 5 Seats • Premium Cabin"
Create-CarSvg -FileName "maruti-baleno-side.svg" -CarName "Maruti Baleno" -Category "HATCHBACK" -BodyColor1 "#1e3a8a" -BodyColor2 "#172554" -AccentColor "#60a5fa" -CarType "hatch" -Subtext "Wide Rear Seat Space & High Mileage"

# 8. Toyota Glanza
Create-CarSvg -FileName "toyota-glanza.svg" -CarName "Toyota Glanza Automatic" -Category "HATCHBACK" -BodyColor1 "#dc2626" -BodyColor2 "#991b1b" -AccentColor "#f87171" -CarType "hatch" -Subtext "Automatic • Petrol • 5 Seats • Toyota Comfort"
Create-CarSvg -FileName "toyota-glanza-side.svg" -CarName "Toyota Glanza AT" -Category "HATCHBACK" -BodyColor1 "#dc2626" -BodyColor2 "#991b1b" -AccentColor "#f87171" -CarType "hatch" -Subtext "Smooth Automatic Drive & Dual Tone Cabin"

# 9. Hyundai i20 MT
Create-CarSvg -FileName "hyundai-i20.svg" -CarName "Hyundai i20 MT" -Category "HATCHBACK" -BodyColor1 "#0f766e" -BodyColor2 "#115e59" -AccentColor "#2dd4bf" -CarType "hatch" -Subtext "Manual • Petrol • 5 Seats • European Styling"
Create-CarSvg -FileName "hyundai-i20-side.svg" -CarName "Hyundai i20 Manual" -Category "HATCHBACK" -BodyColor1 "#0f766e" -BodyColor2 "#115e59" -AccentColor "#2dd4bf" -CarType "hatch" -Subtext "Sharp Steering & Digital Cockpit"

# 10. Hyundai i20 Automatic
Create-CarSvg -FileName "hyundai-i20-auto.svg" -CarName "Hyundai i20 Automatic" -Category "HATCHBACK" -BodyColor1 "#7c3aed" -BodyColor2 "#5b21b6" -AccentColor "#c084fc" -CarType "hatch" -Subtext "Automatic (IVT) • Petrol • 5 Seats • Cruise Control"
Create-CarSvg -FileName "hyundai-i20-auto-side.svg" -CarName "Hyundai i20 Auto" -Category "HATCHBACK" -BodyColor1 "#7c3aed" -BodyColor2 "#5b21b6" -AccentColor "#c084fc" -CarType "hatch" -Subtext "Step-less Seamless Acceleration"

# Interior Views
function Create-InteriorSvg {
    param([string]$FileName, [string]$Title, [string]$Subtitle, [string]$Badge)
    $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="100%" height="100%">
  <defs>
    <linearGradient id="intBg" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#0f172a"/>
      <stop offset="100%" stop-color="#1e293b"/>
    </linearGradient>
    <linearGradient id="screenGlow" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0284c7"/>
      <stop offset="100%" stop-color="#0f766e"/>
    </linearGradient>
  </defs>
  <rect width="100%" height="100%" fill="url(#intBg)"/>
  <!-- Steering Wheel Silhouette -->
  <circle cx="280" cy="300" r="110" fill="none" stroke="#334155" stroke-width="26"/>
  <circle cx="280" cy="300" r="45" fill="#0f172a" stroke="#475569" stroke-width="4"/>
  <line x1="235" y1="300" x2="170" y2="300" stroke="#334155" stroke-width="20"/>
  <line x1="325" y1="300" x2="390" y2="300" stroke="#334155" stroke-width="20"/>
  <line x1="280" y1="345" x2="280" y2="410" stroke="#334155" stroke-width="20"/>
  <!-- Infotainment Display -->
  <rect x="440" y="200" width="220" height="130" rx="10" fill="#090d16" stroke="#475569" stroke-width="3"/>
  <rect x="450" y="210" width="200" height="110" rx="6" fill="url(#screenGlow)" opacity="0.8"/>
  <text x="550" y="260" fill="#ffffff" font-family="-apple-system, BlinkMacSystemFont, sans-serif" font-size="16" font-weight="700" text-anchor="middle">Car Rental Dehradun</text>
  <text x="550" y="285" fill="#ccfbf1" font-family="-apple-system, BlinkMacSystemFont, sans-serif" font-size="12" text-anchor="middle">Navigation • Bluetooth • AC</text>
  <!-- AC Vents -->
  <rect x="450" y="155" width="90" height="30" rx="4" fill="#090d16" stroke="#334155" stroke-width="2"/>
  <rect x="560" y="155" width="90" height="30" rx="4" fill="#090d16" stroke="#334155" stroke-width="2"/>
  <!-- Header Text -->
  <g transform="translate(50, 60)">
    <rect x="0" y="0" width="130" height="26" rx="13" fill="#0f766e" opacity="0.4"/>
    <text x="65" y="17" fill="#2dd4bf" font-family="-apple-system, BlinkMacSystemFont, sans-serif" font-size="12" font-weight="700" text-anchor="middle">$Badge</text>
    <text x="0" y="60" fill="#ffffff" font-family="-apple-system, BlinkMacSystemFont, sans-serif" font-size="26" font-weight="800">$Title</text>
    <text x="0" y="85" fill="#94a3b8" font-family="-apple-system, BlinkMacSystemFont, sans-serif" font-size="14">$Subtitle</text>
  </g>
</svg>
"@
    $targetPath = Join-Path $carsDir $FileName
    [System.IO.File]::WriteAllText($targetPath, $svg, [System.Text.Encoding]::UTF8)
    Write-Host "Created interior: images/cars/$FileName" -ForegroundColor Green
}

Create-InteriorSvg -FileName "interior-sedan.svg" -Title "Premium Sedan Interior" -Subtitle "Clean dual-tone cabin, powerful AC & touchscreen audio" -Badge "CABIN VIEW"
Create-InteriorSvg -FileName "interior-suv.svg" -Title "High-View SUV Cockpit" -Subtitle "Commanding driving position, hill assist & digital cluster" -Badge "CABIN VIEW"
Create-InteriorSvg -FileName "interior-7seater.svg" -Title "Spacious 7-Seater Interior" -Subtitle "Triple-row seating with dedicated rear AC ventilation" -Badge "CABIN VIEW"
Create-InteriorSvg -FileName "interior-thar.svg" -Title "Thar 4x4 Adventure Cabin" -Subtitle "Hard top insulation, adventure gauges & roll cage" -Badge "CABIN VIEW"

Write-Host "All 24 Vehicle Asset Files Generated Successfully!" -ForegroundColor Cyan
