$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:8080/"
$listener.Prefixes.Add($prefix)
$listener.Start()

$wwwRoot = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\server-doc"
$logPfad = "C:\Users\qather\Documents\Projekte-alle\PowerShell commands\PowerShell basics\server-doc\log.txt"
Write-host "Server läuft auf $prefix - mit STRG+C stoppen" -ForegroundColor Green


# === funktionen ===
function Get-MimeType($filePath) {
    $ext = [IO.Path]::GetExtension($filePath)
    if ([string]::IsNullOrWhiteSpace($ext)) {
        return "unknown/none"
    }

    $key = "Registry::HKEY_CLASSES_ROOT\$ext"
    $mime = (Get-ItemProperty -Path $key -Name "Content Type" -ErrorAction SilentlyContinue)."Content Type"

    if ([string]::IsNullOrWhiteSpace($mime)) {
        return "application/octet-stream"
    }

    return $mime
}

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

function Get-MimeReportHtml {
    $gruppen = @{}

    Get-ChildItem -Path $wwwRoot -File -Recurse | ForEach-Object {
        $mime = Get-MimeType $_.FullName

        if (-not $gruppen.ContainsKey($mime)) {
            $gruppen[$mime] = @()
        }

        # Relativer Pfad (für Links im Browser)
        $relPath = $_.FullName.Substring($wwwRoot.Length + 1) -replace "\\", "/"
        $gruppen[$mime] += $relPath
    }

    $html = @"
        <html>
        <head>
            <title>MIME Report</title>
            <style>
                body { font-family: sans-serif; padding: 20px; }
                h2 { color: #0066cc; margin-top: 20px; }
                ul { margin: 0 0 20px 20px; }
                li a { text-decoration: none; color: #333; }
                li a:hover { text-decoration: underline; color: #0066cc; }
            </style>
        </head>
        <body>
            <h1>MIME-Report</h1>
"@

    foreach ($mime in $gruppen.Keys) {
        $html += "<h2>$mime</h2><ul>"
        foreach ($file in $gruppen[$mime]) {
            $encodedFile = [System.Web.HttpUtility]::UrlPathEncode($file)
            $html += "<li><a href='/$encodedFile'>$file</a></li>"
        }
        $html += "</ul>"
    }

    $html += "</body></html>"
    return $html
}

loggen -Text "Server gestartet auf $prefix" -Level "INFO" -Trenner

# === Server lauscht - dauerhaft
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $path = $request.Url.AbsolutePath.TrimStart("/")


    if ($request.Url.AbsolutePath -eq "/exit") {
        $response.Close()
        $listener.Stop()
        Write-host "Server gestoppt auf $prefix" -ForegroundColor Red
        loggen -Text "Server gestoppt" -Level "INFO" -Trenner
        break
    }

    if ($request.Url.AbsolutePath -eq "/mime-report") {
        $html = Get-MimeReportHtml
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($html)
        $response.ContentType = "text/html"
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.Close()
        loggen -Text " /mime-report Anfragen von $path" -Level "INFO" 
        continue
    }
    
    if ($request.HttpMethod -eq "POST" -and $path -eq "kontakt") {
        $reader = New-Object System.IO.StreamReader($request.InputStream)
        $body = $reader.ReadToEnd()
    
        # Daten parsen (Formulardaten: name=Max&email=max@example.com...)
        $parsed = [System.Web.HttpUtility]::ParseQueryString($body)
    
        $name = $parsed["name"]
        $email = $parsed["email"]
        $nachricht = $parsed["nachricht"]
    
        loggen -Text "Kontaktformular erhalten: Name=$name | E-Mail=$email | Nachricht=$nachricht" -Level "INFO"
        
        # speicher die Daten
        $savePfad = "$wwwRoot\formulare.csv"
        $zeile = "$name;$email;$nachricht"

        # Datei anlegen, wenn sie noch nicht existiert
        if (-not (Test-Path $savePfad)) {
            "Name;Email;Nachricht" | Out-File $savePfad -Encoding UTF8
        }

        # Zeile anhängen
        $zeile | Out-File -Append -FilePath $savePfad -Encoding UTF8

        # Antwort an den Browser
        $antwort = "<html><body><h1>Danke $name!</h1><p>Deine Nachricht wurde gesendet.</p></body></html>"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($antwort)
        $response.ContentType = "text/html"
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
        $response.Close()
        continue
    }    
    
    if ($request.HttpMethod -eq "GET") {
        if ([string]::IsNullOrWhiteSpace($path)) {
            $path = "index.html"
            loggen -Text "GET Anfragen von $path -> Home-Start" -Level "INFO" 
        }

        $fullPath = Join-Path $wwwRoot $path

        if (Test-Path $fullPath) {

            $mime = Get-MimeType $fullPath

            $bytes = [System.IO.File]::ReadAllBytes($fullPath)
            $response.ContentType = $mime
            Write-Host "→ $path → MIME: $mime" -ForegroundColor Cyan
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
            loggen -Text "GET Anfragen von $path → MIME: $mimet" -Level "INFO" 
        } else {
            # Datei nicht gefunden → Fehlerseite
            $antwort = "<html><body><h1>404 - Datei nicht gefunden</h1><p>$path</p></body></html>"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($antwort)
            $response.ContentType = "text/html"
            $response.ContentLength64 = $buffer.Length
            $response.StatusCode = 404
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            loggen -Text "Datei nicht gefunden $path → 404" -Level "WARNING" 
        }

        $response.Close()
    }
}

<#
Feature | Status | Details
HTTP-Server mit HttpListener | ✅ | Lokaler Listener auf localhost:8080
GET-Handling | ✅ | Dateien werden ausgeliefert, inkl. MIME-Erkennung
POST-Handling | ✅ | Kontaktformular wird verarbeitet
Formulardaten speichern (CSV) | ✅ | Kontakt wird in .csv abgelegt
Log-Funktion mit Leveln & Trenner | ✅ | Flexible Logfunktion mit [INFO], [WARN], etc.
MIME-Type-Erkennung | ✅ | Über die Registry mit Fallback
404-Fehlerbehandlung | ✅ | Fehlermeldung + StatusCode korrekt
/mime-report-Ansicht | ✅ | Übersicht der Dateien nach MIME
Start- und Stop-Logik | ✅ | exit-Route + Stop-Meldung im Log
Standard-Datei (index.html) | ✅ | Wird bei / geladen
#> 