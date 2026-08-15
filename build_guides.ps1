$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$jsonPath = Join-Path $scriptDir "data\guides_data.json"
$tplPath = Join-Path $scriptDir "travel-guides\template.html"
$guideDir = Join-Path $scriptDir "travel-guides"

$rawJson = [System.IO.File]::ReadAllText($jsonPath, [System.Text.Encoding]::UTF8)
$guides = $rawJson | ConvertFrom-Json
$template = [System.IO.File]::ReadAllText($tplPath, [System.Text.Encoding]::UTF8)

foreach ($g in $guides) {
    $slug = [string]$g.slug
    $title = [string]$g.title
    $desc = [string]$g.metaDesc
    $h1 = [string]$g.h1
    $category = [string]$g.category
    $readTime = [string]$g.readTime
    $intro = [string]$g.intro

    $sectionsSb = New-Object System.Text.StringBuilder
    foreach ($s in $g.sections) {
        $sHeading = $s.heading
        $sContent = $s.content
        # Convert simple markdown bold **text** to <strong>text</strong>
        $sContentHtml = $sContent -replace '\*\*(.*?)\*\*', '<strong>$1</strong>'
        [void]$sectionsSb.Append("<h3 style='color:var(--text-main); font-size:1.3rem; margin:1.75rem 0 0.6rem;'>$sHeading</h3><p style='margin-bottom:1.25rem; font-size:1.02rem;'>$sContentHtml</p>")
    }

    $faqSb = New-Object System.Text.StringBuilder
    $faqSchemaList = New-Object System.Collections.Generic.List[string]
    foreach ($f in $g.faqs) {
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
    $page = $page.Replace("{{TITLE}}", $title)
    $page = $page.Replace("{{DESC}}", $desc)
    $page = $page.Replace("{{H1}}", $h1)
    $page = $page.Replace("{{CATEGORY}}", $category)
    $page = $page.Replace("{{READ_TIME}}", $readTime)
    $page = $page.Replace("{{INTRO}}", $intro)
    $page = $page.Replace("{{SECTIONS_HTML}}", $sectionsSb.ToString())
    $page = $page.Replace("{{FAQ_HTML}}", $faqSb.ToString())
    $page = $page.Replace("{{FAQ_SCHEMA}}", $faqSchemaJson)

    $targetFile = Join-Path $guideDir "$slug.html"
    [System.IO.File]::WriteAllText($targetFile, $page, [System.Text.Encoding]::UTF8)
    Write-Host "Generated: travel-guides/$slug.html" -ForegroundColor Green
}

Write-Host "Generated all $($guides.Count) Travel Guide Articles!" -ForegroundColor Cyan
