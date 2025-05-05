$pfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash"
$dateien = Get-ChildItem -Path $pfad -Filter *.txt
$anzahl = ($dateien | Measure-Object).Count
$dateien | Out-File "$pfad\log.txt"
Add-Content "$pfad\log.txt" "Anzahl: $anzahl"
Get-Content "$pfad\log.txt"


# Was macht Measure-Object?
#Es misst:
    # Anzahl (.Count)
    #Summe, Durchschnitt, Minimum, Maximum von Zahlenwerten

# Gesamtgröße aller Dateien:
# (Get-ChildItem *.txt | Measure-Object Length -Sum).Sum

# Durchschnittliche Dateigröße:
# (Get-ChildItem *.txt | Measure-Object Length -Average).Average
