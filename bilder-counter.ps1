# === Konfiguration ===
$quelle = "F:\"
$zielBasis = "C:\Users\qather\Pictures\ani_Bilder\Ani Handy\DCIM\Camera-SD"

# === Zielordner vorbereiten ===
New-Item -Path $zielBasis -ItemType Directory -Force | Out-Null

# === Alle Dateien rekursiv sammeln ===
Write-Host "`nScanne Verzeichnisstruktur... (kann kurz dauern)" -ForegroundColor Cyan
$alleDateien = Get-ChildItem -Path $quelle -Recurse -File
$gesamt = $alleDateien.Count
Write-Host "`nGefundene Dateien insgesamt: $gesamt (nun werden nur Bilder gezählt...)" -ForegroundColor DarkYellow

# === Bildfilter mit Ladebalken ===
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

    Write-Progress -Activity "Suche Bilder (.jpg/.png)" -Status "$counter von $gesamt Dateien überprüft – $bildCounter Bilder gefunden" -PercentComplete (($counter / $gesamt) * 100)
}

Write-Progress -Activity "Suche Bilder" -Completed
Write-Host "`nErgebnis: $bildCounter Bilddateien gefunden." -ForegroundColor Green
