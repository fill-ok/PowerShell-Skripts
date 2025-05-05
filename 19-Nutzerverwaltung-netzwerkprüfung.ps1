$logPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\log-19.txt"

#funktionen
function loggen {
    param (
        [string]$Text,
        [ValidateSet("INFO", "WARN", "ERROR")] [string]$Level = "INFO",
        [switch]$Trenner
    )

    $zeit = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $prefix = "[$zeit] [$Level]"

    if ($Trenner) {
        $newLog = ("=" * 80) + "`n" + "$prefix $Text" + "`n" + ("=" * 80)
        $altLog = Get-Content $logPfad -ErrorAction SilentlyContinue
        $newLog, $altLog | Set-Content $logPfad        
    }
    else {
        $newLog = "$prefix $Text"
        $altLog = Get-Content $logPfad -ErrorAction SilentlyContinue
        $newLog, $altLog | Set-Content $logPfad  
    }
}


$passwort = ConvertTo-SecureString "123" -AsPlainText -Force

   if (-not (Get-LocalUser -Name "BackupAdmin" -ErrorAction SilentlyContinue)){
        New-LocalUser -Name "BackupAdmin" -Password $passwort -FullName "Backup Admin" -Description "Backup Konto" -AccountNeverExpires -PasswordNeverExpires
        loggen -Text "User: *BackupAdmin* wurde erstellt" -Level INFO
        Write-Host "User:" -NoNewline
        Write-Host " BackupAdmin " -ForegroundColor Green -NoNewline
        Write-Host "wurde erstellt" -NoNewline

        
        Add-LocalGroupMember -Group "Administratoren" -Member "BackupAdmin"

        Write-Host "User:" -NoNewline
        Write-Host " BackupAdmin " -ForegroundColor Green -NoNewline
        Write-Host "erfolgreich zu Group: " -NoNewline
        Write-Host " Administrators " -ForegroundColor Green -NoNewline
    } else {
        loggen -Text "User: *BackupAdmin* bereits vorhanden" -NoNewline
        Write-Host "User:" -NoNewline
        Write-Host " BackupAdmin " -ForegroundColor Green -NoNewline
        Write-Host "bereits vorhanden " -NoNewline
    }

    
