$dateiname = Read-Host "Wie soll die Datei genannt werden?"
$dateiVorhanden = Test-Path "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\$dateiname"
$path = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\$dateiname"

if ($dateiVorhanden){
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')] Datei war vorhanden"
}
else{

    New-Item -Path $path -ItemType File | Out-NUll
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')] Datei wurde erstellt"
}
Remove-Item -Path $path


