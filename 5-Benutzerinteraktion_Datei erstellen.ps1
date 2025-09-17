$dateiname = Read-Host "Wie soll die Datei heißen?"
$pfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\$dateiname.txt"
New-Item -Path $pfad -ItemType File -Force
Add-Content $pfad "Dies ist eine auto generierte Datei."
Write-Host "Datei wurde erstellt!"

