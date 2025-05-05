$eingabe = Read-Host "RAM-Schwellenwert in MB?"
$schwelle = [int]$eingabe * 1MB
$zielpfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\ram-check.csv"
$prozesse = Get-Process | Where-Object {$_.WorkingSet -gt $schwelle} 

$prozesse | ForEach-Object {
    [PSCustomObject]@{
        Name = $_.ProcessName
        RAM_MB = [math]::Round($_.WorkingSet / 1MB ,2)
    }
} | Export-Csv -Path $zielpfad -NoTypeInformation -Encoding UTF8
Write-Host "Export abgeschlossen!:" -ForegroundColor Green
Write-Host "Anzahl der Prozesse ueber $eingabe MB: $($prozesse.Count)" -ForegroundColor Cyan
Write-Host $zielpfad -ForegroundColor Yellow
