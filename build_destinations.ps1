$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$jsonPath = Join-Path $scriptDir "data\destinations_data.json"
$tplPath = Join-Path $scriptDir "destinations\template.html"
$destDir = Join-Path $scriptDir "destinations"

$rawJson = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$destinations = $rawJson | ConvertFrom-Json
$template = [System.IO.File]::ReadAllText($tplPath, [System.Text.Encoding]::UTF8)

foreach ($dest in $destinations) {
    $slug = [string]$dest.slug
    $name = [string]$dest.name
    $region = [string]$dest.region
    $dist = [string]$dest.distFromBase
    $title = [string]$dest.title
    $desc = [string]$dest.metaDesc
    $h1 = [string]$dest.h1
    $intro = [string]$dest.intro
    $howToReach = [string]$dest.howToReach
    $recCars = [string]$dest.recCars
    $parkingInfo = [string]$dest.parkingInfo

    $sightseeingSb = New-Object System.Text.StringBuilder
    foreach ($s in $dest.sightseeing) {
        $sName = $s.name
        $sDesc = $s.desc
        [void]$sightseeingSb.Append("<div class='feature-card'><h4 style='color:var(--primary-dark); margin-bottom:0.4rem;'>$sName</h4><p style='font-size:0.9rem; line-height:1.6;'>$sDesc</p></div>")
    }

    $faqSb = New-Object System.Text.StringBuilder
    $faqSchemaList = New-Object System.Collections.Generic.List[string]
    foreach ($f in $dest.faqs) {
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
    $page = $page.Replace("{{NAME}}", $name)
    $page = $page.Replace("{{REGION}}", $region)
    $page = $page.Replace("{{DIST}}", $dist)
    $page = $page.Replace("{{TITLE}}", $title)
    $page = $page.Replace("{{DESC}}", $desc)
    $page = $page.Replace("{{H1}}", $h1)
    $page = $page.Replace("{{INTRO}}", $intro)
    $page = $page.Replace("{{HOW_TO_REACH}}", $howToReach)
    $page = $page.Replace("{{REC_CARS}}", $recCars)
    $page = $page.Replace("{{PARKING_INFO}}", $parkingInfo)
    $page = $page.Replace("{{SIGHTSEEING_HTML}}", $sightseeingSb.ToString())
    $page = $page.Replace("{{FAQ_HTML}}", $faqSb.ToString())
    $page = $page.Replace("{{FAQ_SCHEMA}}", $faqSchemaJson)

    $targetFile = Join-Path $destDir "$slug.html"
    [System.IO.File]::WriteAllText($targetFile, $page, [System.Text.Encoding]::UTF8)
    Write-Host "Generated: destinations/$slug.html" -ForegroundColor Green
}

Write-Host "Generated all $($destinations.Count) Destination Pages!" -ForegroundColor Cyan
