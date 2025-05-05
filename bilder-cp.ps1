# === Konfiguration ===
$quelle = "F:\"
$zielBasis = "C:\Users\qather\Pictures\ani_Bilder\Ani Handy\DCIM\Camera-SD"
$dateienProBlock = 2000

# === Zielordner vorbereiten ===
New-Item -Path $zielBasis -ItemType Directory -Force | Out-Null

# === Alle Dateien sammeln ===
Write-Host "`nScanne Verzeichnisstruktur..." -ForegroundColor Cyan
$alleDateien = Get-ChildItem -Path $quelle -Recurse -File
$gesamt = $alleDateien.Count
Write-Host "`nGefundene Dateien insgesamt: $gesamt (filtere jetzt nur Bildformate...)" -ForegroundColor DarkYellow

# === Bildfilter mit Ladebalken beim Sammeln ===
$bilder = @()
$counter = 0
$bildCounter = 0

foreach ($datei in $alleDateien) {
    $counter++
    $ext = $datei.Extension.ToLower()
    if ($ext -eq ".jpg" -or $ext -eq ".jpeg" -or $ext -eq ".png") {
        $bilder += $datei
        $bildCounter++
    }

    Write-Progress -Activity "Filtere Bilder (.jpg/.png)" -Status "$counter von $gesamt überprüft – $bildCounter Bilder gefunden" -PercentComplete (($counter / $gesamt) * 100)
}

Write-Progress -Activity "Filter abgeschlossen" -Completed
Write-Host "`nInsgesamt gefunden: $bildCounter Bilder" -ForegroundColor Green

# === Schleife: In 2000er-Blöcken verarbeiten ===
$gesamt = $bilder.Count
$counter = 0
$blockNr = 1

# === Monatsnamen (Deutsch)
$monatsnamen = @{
    1 = "Januar"; 2 = "Februar"; 3 = "März"; 4 = "April"
    5 = "Mai"; 6 = "Juni"; 7 = "Juli"; 8 = "August"
    9 = "September"; 10 = "Oktober"; 11 = "November"; 12 = "Dezember"
}

for ($i = 0; $i -lt $gesamt; $i += $dateienProBlock) {
    $block = $bilder[$i..([math]::Min($i + $dateienProBlock - 1, $gesamt - 1))]
    Write-Host "`nStarte Block $blockNr mit $($block.Count) Bildern..." -ForegroundColor Yellow

    foreach ($bild in $block) {
        $creation = $bild.CreationTime

        if ($creation.Year -lt 2000) {
            $zielOrdner = Join-Path $zielBasis "Unbekannt"
        } else {
            $jahr = $creation.Year.ToString()
            $monatNum = "{0:D2}" -f $creation.Month
            $monatName = $monatsnamen[$creation.Month]
            $monatOrdner = "${monatNum}_$monatName"
            $zielOrdner = Join-Path $zielBasis (Join-Path $jahr $monatOrdner)
        }

        if (-not (Test-Path $zielOrdner)) {
            New-Item -Path $zielOrdner -ItemType Directory -Force | Out-Null
        }

        $zielDatei = Join-Path $zielOrdner $bild.Name

        if (-not (Test-Path $zielDatei)) {
            try {
                Copy-Item -Path $bild.FullName -Destination $zielDatei -ErrorAction Stop
            } catch {
                Write-Warning "Fehler beim Kopieren von $($bild.FullName): $_"
            }
        }

        $counter++
        Write-Progress -Activity "Kopiere Block $blockNr..." -Status "$counter von $gesamt kopiert" -PercentComplete (($counter / $gesamt) * 100)
    }

    $blockNr++
}

Write-Progress -Activity "Kopieren abgeschlossen" -Completed
Write-Host "`nFertig! Alle Bilder wurden nach Jahr und Monat (mit Namen) sortiert kopiert." -ForegroundColor Green
