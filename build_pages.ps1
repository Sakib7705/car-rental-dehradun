$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$jsonPath = Join-Path $scriptDir "data\locations_data.json"
$tplPath = Join-Path $scriptDir "locations\template.html"
$locDir = Join-Path $scriptDir "locations"

$rawJson = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$locations = $rawJson | ConvertFrom-Json
$template = [System.IO.File]::ReadAllText($tplPath, [System.Text.Encoding]::UTF8)

foreach ($loc in $locations) {
    $slug = [string]$loc.slug
    $city = [string]$loc.city
    $title = [string]$loc.title
    $desc = [string]$loc.metaDesc
    $h1 = [string]$loc.h1
    $tagline = [string]$loc.tagline
    $intro = [string]$loc.intro
    $recVehicles = [string]$loc.recommendedVehicles

    $pickupsSb = New-Object System.Text.StringBuilder
    foreach ($p in $loc.pickupPoints) {
        [void]$pickupsSb.Append("<li style='margin-bottom:0.4rem;'>&#128205; $p</li>")
    }

    $attractionsSb = New-Object System.Text.StringBuilder
    foreach ($a in $loc.nearbyAttractions) {
        $aName = $a.name
        $aDist = $a.dist
        [void]$attractionsSb.Append("<div style='background:var(--bg-card); padding:1rem 1.25rem; border-radius:var(--radius-md); border:1px solid var(--border);'><strong style='color:var(--text-main); display:block; margin-bottom:0.2rem;'>$aName</strong><small style='color:var(--text-muted);'>$aDist</small></div>")
    }

    $faqSb = New-Object System.Text.StringBuilder
    $faqSchemaList = New-Object System.Collections.Generic.List[string]
    foreach ($f in $loc.faqs) {
        $q = [string]$f.q
        $ans = [string]$f.a
        [void]$faqSb.Append("<div class='faq-item'><button class='faq-question'><span>$q</span><span class='faq-icon'>&#9660;</span></button><div class='faq-answer'>$ans</div></div>")
        
        $escapedQ = $q.Replace('"', '\"')
        $escapedAns = $ans.Replace('"', '\"')
        $faqSchemaList.Add("{`"@type`":`"Question`",`"name`":`"$escapedQ`",`"acceptedAnswer`":{`"@type`":`"Answer`",`"text`":`"$escapedAns`"}}")
    }
    $faqSchemaJson = $faqSchemaList -join ","

    $page = $template
    $page = $page.Replace("{{SLUG}}", $slug)
    $page = $page.Replace("{{CITY}}", $city)
    $page = $page.Replace("{{TITLE}}", $title)
    $page = $page.Replace("{{DESC}}", $desc)
    $page = $page.Replace("{{H1}}", $h1)
    $page = $page.Replace("{{TAGLINE}}", $tagline)
    $page = $page.Replace("{{INTRO}}", $intro)
    $page = $page.Replace("{{REC_VEHICLES}}", $recVehicles)
    $page = $page.Replace("{{PICKUPS_HTML}}", $pickupsSb.ToString())
    $page = $page.Replace("{{ATTRACTIONS_HTML}}", $attractionsSb.ToString())
    $page = $page.Replace("{{FAQ_HTML}}", $faqSb.ToString())
    $page = $page.Replace("{{FAQ_SCHEMA}}", $faqSchemaJson)

    $targetFile = Join-Path $locDir "$slug.html"
    [System.IO.File]::WriteAllText($targetFile, $page, [System.Text.Encoding]::UTF8)
    Write-Host "Generated: locations/$slug.html" -ForegroundColor Green
}

Write-Host "Generated all $($locations.Count) Location Pages!" -ForegroundColor Cyan
