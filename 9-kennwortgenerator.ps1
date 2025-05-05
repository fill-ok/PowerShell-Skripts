$anzahlPasswoerter = Read-Host "Wie viele Kennwoerter sollen generiert werden?"
$laenge = Read-Host "Wie lang soll das Kennwort sein?"
$zielpfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\trash\passwoerter.txt"

if (Test-Path $zielpfad) {
    Remove-Item -Path $zielpfad -Force
}

New-Item -Path $zielpfad -ItemType File


for($i=1; $i -le $anzahlPasswoerter; $i++){
    # Zeichenklassen definieren
    $klein = 'abcdefghijklmnopqrstuvwxyz'
    $gross = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $zahlen = '0123456789'
    $sonder = '!@#$%^&*()-_=+[]{}?'

    $garantiert = @(
        $klein.ToCharArray() | Get-Random -Count 1
        $gross.ToCharArray() | Get-Random -Count 1
        $zahlen.ToCharArray() | Get-Random -Count 1
        $sonder.ToCharArray() | Get-Random -Count 1
    )

    # Alle zeichen zusammenführen
    $alleZeichen = ($klein + $gross + $zahlen + $sonder).ToCharArray()

    # restliche länge an zeichen füllen
    $rest = $laenge -$garantiert.Count
    $zufall = 1..$rest | ForEach-Object { $alleZeichen | Get-Random}

    # alle zeichen mischen
    $final = ($garantiert + $zufall) | Get-Random -Count $laenge
    $passwort = -join $final
    Add-Content -Path $zielpfad -Value "$i. $passwort" 
}

Write-Host "===== Alle $anzahlPasswoerter Passwoerter wurden erstellt in $zielpfad =====" -ForegroundColor Green 
Get-Content -Path $zielpfad