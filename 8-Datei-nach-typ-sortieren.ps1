$zielpfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\solution"
$suchpfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash"

Get-ChildItem -Path $suchpfad -File | Group-Object Extension | ForEach-Object {
    $endung = $_.Name.TrimStart('.')
    $zielordner = Join-Path $zielpfad $endung

    # Ordner erstellen, falls nicht vorhanden
    if (-not (Test-Path $zielordner)){
        New-item -Path $zielordner -ItemType Directory -WhatIf
    }

    #Dateien verschieben
    $_.Group | ForEach-Object {
        Move-Item -Path $_.FullName -Destination $zielordner -WhatIf
    }
}

Write-Host "===== Dateien wurden nach Endungen sortiert und verschoben! =====" -ForegroundColor Green

