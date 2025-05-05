

# csv einlesen 
$csvPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\13-test.csv"
$logPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\13-test-log.txt"
$userlist = Import-Csv -Path $csvPfad

#funktionen
function loggen {
    param ($neulog)
    $altLog = @()

    if (Test-Path $logPfad) {
        $altLog = Get-Content $logPfad
    }
    # Neuen Log schreiben + alte anhängen
    $neuLog, $altLog | Set-Content -Path $logPfad
}
foreach ($user in $userlist) {
    $name = $user.Name
    $username = $user.Benutzername
    $passwort = $user.Passwort
    $rolle = $user.Rolle

    try {
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue){
            Write-Host "[User: '" -NoNewline
            Write-Host $username -ForegroundColor Red -NoNewline
            Write-Host "'existiert bereits - wird uebersprungen]" -ForegroundColor Gray    
            loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- user '$username' existiert bereits - wird uebersprungen.")
            continue
        }
        
            # Benutzer erstellen
            $securePwd = ConvertTo-SecureString $passwort -AsPlainText -Force
            New-LocalUser -Name $username -Password $securePwd -FullName $name -Description "Erstellt via Skript"

            # Gruppe hinzufügen
            Add-LocalGroupMember -Group $rolle -Member $username

            # Erfolg loggen
            Write-Host "[User: '" -NoNewline
            Write-Host $username -ForegroundColor Green -NoNewline
            Write-Host "' wurde hinzugefuegt]" -ForegroundColor Gray
            loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- user '$username' erfolgreich erstellt und zu Gruppe '$rolle' hinzugefuegt.")
        
    }
    catch {
        #fehler loggen
        loggen("[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] --- Bei user '$username' ist ein unerwarteter Fehler aufgetreten")
        Write-Host "[User: '" -NoNewline
        Write-Host "Fehler bei $username" -ForegroundColor Red -NoNewline
        Write-Host "]" -ForegroundColor Gray
    }

}


Write-Host "`nBenutzerverwaltung abgeschlossen." -ForegroundColor Green
Write-Host "Log-Datei: $logPfad" -ForegroundColor Yellow
Get-LocalUser
