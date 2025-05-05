$quellPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\systembericht.html"
$zeit = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$titel = "Systembericht - erstellt am $zeit"

# === HTML-header mit styling ===
$style = @"
<style>
    body { font-family: Arial; background-color: #f4f4f4; color: #333; padding: 20px; }
    h1 { color: #0066cc; }
    h2 { color: #333; margin-top: 30px; }
    table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    th, td { border: 1px solid #999; padding: 8px; text-align: left; }
    th { background-color: #e6f0ff; }
    tr:nth-child(even) { background-color: #f9f9f9; }
</style>
"@


$class = @('OperatingSystem', 'Processor', 'PhysicalMemory', 'LogicalDisk', 'BIOS') 
$count = $class.Count
# === schleife ===
$listSys = @()
$i = 1


$class | ForEach-Object {

    # === progresss bar ===
    $percent = [math]::Round(($i / $count) * 100, 0)

    Write-Progress -Activity "In progress..." -Status $_ -PercentComplete $percent
    Start-Sleep -Milliseconds 200
    # === Bericht-Daten sammeln ===
    $htmlBlock = Get-CimInstance Win32_$_ | ConvertTo-Html -As Table -PreContent "<h2>$_</h2>"
    $listSys += $htmlBlock -join "`n"
    $i++
}

$listHtml = $listSys -join "`n"

# === HTML-Seite zusammensetzen ===
$gesamtbericht = @"
<html>
<head>
    <title>$titel</title>
    $style
</head>
<body>
    <h1>Systembericht</h1>
    <p>Erstellt am: $zeit</p>

    $listHtml
</body>
</html>
"@

# === Datei schreiben und im Browser öffnen ===
$gesamtbericht | Out-File -FilePath $quellPfad -Encoding UTF8
Start-Process $quellPfad

# === console verweise ===
Write-Host "=== Der Bericht wurde erfolgreich erstellt ===" -ForegroundColor Green