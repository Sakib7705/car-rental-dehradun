Add-Type -AssemblyName System.IO.Compression.FileSystem

$apkPath = "d:\Car-rental-dehradun.com\android-build-artifacts\CarRentalDehradun-release.apk"

$zip = [System.IO.Compression.ZipFile]::OpenRead($apkPath)
$resEntries = $zip.Entries | Where-Object { $_.FullName.StartsWith('res/') }
Write-Host "Total resource files in APK: $($resEntries.Count)"
foreach ($e in $resEntries | Select-Object -First 30) {
    Write-Host "  $($e.FullName) ($($e.Length) bytes)"
}
$zip.Dispose()
