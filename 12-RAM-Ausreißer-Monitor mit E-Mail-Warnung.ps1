param (
    [switch]$TestMode
)

# === Konfiguration ===
$schwelleMB = 500
$maxProzesse = 5
$ramGrenzeBytes = $schwelleMB * 1MB
$reportPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\ram-report.csv"

# === RAM-intensive Prozesse sammeln ===
$prozesse = Get-Process | Where-Object { $_.WorkingSet -gt $ramGrenzeBytes }

# === Wenn Prozesse gefunden wurden, CSV erstellen ===
if ($prozesse.Count -gt 0) {
    $prozesse | ForEach-Object {
        [PSCustomObject]@{
            Name    = $_.ProcessName
            RAM_MB  = [math]::Round($_.WorkingSet / 1MB, 2)
            ID      = $_.Id
        }
    } | Export-Csv -Path $reportPfad -NoTypeInformation -Encoding UTF8
}

# === Entscheidung: Warnung auslösen? ===
if ($prozesse.Count -gt $maxProzesse) {
    Write-Host " $($prozesse.Count) Prozesse über $schwelleMB MB gefunden!" -ForegroundColor Yellow

    if ($TestMode) {
        Write-Host "TestMode aktiv - keine E-Mail wird gesendet." -ForegroundColor Cyan
    }
    else {
        # === E-Mail-Konfiguration ===
        $smtpServer = "smtp.example.com"
        $absender   = "rammonitor@example.com"
        $empfaenger = "admin@example.com"
        $betreff    = "RAM-Ausreißer-Warnung auf $env:COMPUTERNAME"
        $nachricht  = "Achtung! Auf dem Rechner $env:COMPUTERNAME wurden $($prozesse.Count) Prozesse gefunden, die mehr als $schwelleMB MB RAM nutzen.`nSiehe Anhang."

        try {
            Send-MailMessage -From $absender -To $empfaenger -Subject $betreff -Body $nachricht -SmtpServer $smtpServer -Attachments $reportPfad -Encoding UTF8
            Write-Host "Warn-E-Mail gesendet an $empfaenger" -ForegroundColor Green
        }
        catch {
            Write-Host "Fehler beim Senden der E-Mail:`n$_" -ForegroundColor Red
        }
    }
}
else {
    Write-Host "Alles okay - nur $($prozesse.Count) Prozesse über $schwelleMB MB." -ForegroundColor Green
}

# === Aufräumen / Hinweis ===
if (Test-Path $reportPfad) {
    Write-Host "Bericht gespeichert unter: $reportPfad" -ForegroundColor Cyan
}


