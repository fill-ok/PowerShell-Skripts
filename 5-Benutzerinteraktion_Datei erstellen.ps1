$dateiname = Read-Host "Wie soll die Datei heißen?"
$pfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\$dateiname.txt"
New-Item -Path $pfad -ItemType File -Force
Add-Content $pfad "Dies ist eine auto generierte Datei."
Write-Host "Datei wurde erstellt!"

<#
🔹 $pfad = "C:\Test\$dateiname.txt"

    Baut einen kompletten Pfad zur Datei zusammen:

        Ordner: C:\Test

        Dateiname: was der Benutzer eingegeben hat

        Erweiterung: .txt

    Beispiel: → C:\Test\test123.txt

🔹 New-Item -Path $pfad -ItemType File -Force

    Erstellt eine neue Datei an dem angegebenen Pfad.

    -ItemType File: sagt, dass es eine Datei (nicht ein Ordner) sein soll.

    -Force: überschreibt vorhandene Dateien mit gleichem Namen ohne Nachfrage.

🔹 Add-Content $pfad "Dies ist eine automatisch generierte Datei."

    Schreibt den Text in die Datei hinein.

    Falls schon Inhalt da wäre, würde er am Ende angehängt.

🔹 Write-Host "Datei wurde erstellt: $pfad"

    Gibt eine Rückmeldung im Terminal:
#>