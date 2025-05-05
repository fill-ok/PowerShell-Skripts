$quelle = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash"
$datum = Get-Date -Format "yyyy-MM-dd"
$zip = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\old_zip_$datum"
$log = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\log_$datum.txt"


Get-ChildItem -Path $quelle | Where-Object { $_.Extension -eq ".txt" -or $_.Extension -eq ".log"} |
Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-14)} | 
Select-Object -ExpandProperty Fullname |
Compress-Archive -DestinationPath $zip
"[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Dein Log-Eintrag" | Out-File -FilePath $log -Append
