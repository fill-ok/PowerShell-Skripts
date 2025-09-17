Get-Process | Where-Object { $_.WorkingSet -gt 100MB} |
Select-Object Name, @{Name="RAM_MB";Expression={ [math]::Round($_WorkingSet / 1MB, 2)}} | 
Sort-Object RAM_MB -Descending


