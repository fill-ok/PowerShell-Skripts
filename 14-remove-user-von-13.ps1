# csv einlesen 
$csvPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\13-test.csv"
$logPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\13-test-log.txt"

#funktionen
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

$userList = Import-Csv -Path $csvPfad

foreach ($user in $userList) {
    $username = $user.Benutzername

    try {
        # prüfe, ob user existieren
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue){
              
            Remove-LocalUser -Name $username
            loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- User: '$username' wurde geloescht")
            Write-Host "[User: '" -NoNewline
            Write-Host $username -ForegroundColor Red -NoNewline
            Write-Host "' wurde geloescht]" -ForegroundColor Gray

        }else {
            loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- user '$username' ist nicht vorhanden")
            Write-Host "[User: '" -NoNewline
            Write-Host $username -ForegroundColor Red -NoNewline
            Write-Host "' ist nicht vorhanden]" -ForegroundColor Gray
        }
    }
    catch {
        #fehler loggen
        loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- Bei user '$username' ist ein unerwarteter Fehler aufgetreten")
        Write-Host "[User: '" -NoNewline
        Write-Host "Fehler bei $username" -ForegroundColor Red -NoNewline
        Write-Host "' ist nicht vorhanden]" -ForegroundColor Gray
    }
}
Get-LocalUser