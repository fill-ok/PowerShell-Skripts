$quell = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash"
$ziel = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\backup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"
Copy-Item -Path $quell -Destination $ziel -Recurse
Write-Host "Backup wurde erstellt nach: $ziel"

