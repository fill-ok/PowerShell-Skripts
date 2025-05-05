
$hosts = @("google.com", "microsoft.com", "localhost", "192.168.1.1")
$logPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\15-test-log.txt"

$hosts | ForEach-Object -ThrottleLimit 5 -Parallel {


    $logPfad = $USING:logPfad
    function loggen {
        param ($textlog)
        $altLog = @()
    
        if (Test-Path $logPfad) {
            $altLog = Get-Content $logPfad
        }
        $neuLog = $textlog
        # Neuen Log schreiben + alte anhängen
        $neuLog, $altLog | Set-Content -Path $logPfad
    }



    try {
        $ping = Test-Connection -ComputerName $_ -Count 1 -ErrorAction Stop
        $ms = $ping.Latency
        $status = $ping.Status
        loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- $_ Antwortzeit: $ms  Status: $status")
    }
    catch {
        loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- Bei user '$username' ist ein unerwarteter Fehler aufgetreten")
    }
}
Write-Host "`nFertig! Log gespeichert unter:" -ForegroundColor Green
Write-Host $logPfad -ForegroundColor Yellow