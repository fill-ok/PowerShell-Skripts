Get-Process | Where-Object { $_.WorkingSet -gt 100MB} |
Select-Object Name, @{Name="RAM_MB";Expression={ [math]::Round($_WorkingSet / 1MB, 2)}} | 
Sort-Object RAM_MB -Descending


<#
🔹 Get-Process

    Holt alle aktuell laufenden Prozesse auf deinem System.

    Jeder Prozess hat Infos wie Name, RAM-Verbrauch, ID etc.

🔹 Where-Object { $_.WorkingSet -gt 100MB }

    Filtert nur die Prozesse, deren WorkingSet (also belegter Arbeitsspeicher) größer als 100 MB ist.

    $_.WorkingSet ist die RAM-Nutzung in Bytes

    100MB ist ein PowerShell-Feature – das versteht direkt 100MB als Byte-Größe (also 104.857.600 Bytes)

🔹 Select-Object Name, @{Name="RAM_MB"; Expression={ [math]::Round($_.WorkingSet / 1MB, 2) }}

    Zeigt nur zwei Spalten:

        Name des Prozesses

        Eine neue Spalte namens RAM_MB:

            Berechnet den RAM in Megabyte (WorkingSet / 1MB)

            Rundet auf 2 Nachkommastellen mit [math]::Round(...)

🔹 Sort-Object RAM_MB -Descending

    Sortiert die Liste nach RAM-Verbrauch, von hoch nach niedrig.

#>