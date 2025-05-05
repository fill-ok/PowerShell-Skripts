# Variablen
$quelle = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash"
$backup = "C:\Backup\backup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"

# Sicherstellen, dass der Zielordner existiert
New-Item -Path $backup -ItemType Directory -Force | Out-Null

# Dateien kopieren (nur Inhalt, nicht Quelle selbst)
Copy-Item -Path "$quelle" -Destination $backup -Recurse

# Log-Datei schreiben
Get-ChildItem -Path $quelle | Select-Object -ExpandProperty Name | Out-File -FilePath "$backup\backup-log.txt"

# Bestätigung
Write-Host "===== Backup wurde erstellt in $backup =====" -ForegroundColor Green
