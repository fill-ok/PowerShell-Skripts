Write-Host "Hallo $env:USERNAME"
Write-Host "Heute ist: $(Get-Date)"
Write-Host "Comnputername: $env:COMPUTERNAME"


# $variable	Zugriff auf eine normale Variable
# $env:VARIABLE	Zugriff auf eine Umgebungsvariable
# $(Befehl)	Führt den Befehl aus und gibt das Ergebnis zurück