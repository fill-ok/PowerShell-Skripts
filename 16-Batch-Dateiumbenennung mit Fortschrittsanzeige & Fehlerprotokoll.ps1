$quell = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash"
$logPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\move\16-test-log.txt"

#functions
function loggen {
    param ($textlog)
    $altLog = Get-Content $logPfad -ErrorAction SilentlyContinue
    $textlog, $altLog | Set-Content $logPfad
}


# Rename files
$items = @(Get-childItem $quell -File -Recurse)
$count = $items.Count
$i = 1
$items | ForEach-Object -ErrorAction SilentlyContinue {

    $percent = [math]::Round(($i / $count) * 100, 0)
    $oldName = $_.Name
    $newName = $_.Name.ToUpper()   

    try {      
        Rename-Item -Path $_.FullName -NewName $newName

        loggen("[$(Get-Date -Format 'yyyy-MM-dd  HH-mm-ss')] --- $oldName --> $newName")
        Write-Progress -Activity "In progress..." -Status $_.Name -PercentComplete $percent
        Start-Sleep -Milliseconds 500
    }
    catch {
       loggen("[$(Get-Date -Format 'yyyy-MM-dd  HH-mm-ss')] --- unerwarteter Fehler ist aufgetreten")
       Write-Host "Es ist ein unerwarteter Fehler aufgetreten!" -ForegroundColor Red
    }
    $i++
}
Write-Progress -Activity "Done" -Completed
Write-Host "Fertig! Log gespeichert unter:" -ForegroundColor Green
Write-Host "$logPfad" -ForegroundColor Yellow
