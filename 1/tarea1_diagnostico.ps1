Write-Host "=== DIAGNÓSTICO WINDOWS SERVER ===" -ForegroundColor Cyan
Write-Host "Nombre: $(hostname)"
$IP = Get-NetIPAddress -InterfaceAlias "Ethernet 2" -AddressFamily IPv4 | Select-Object -ExpandProperty IPAddress
Write-Host "IP Interna: $IP"
Get-PSDrive C | Select-Object @{N='Libre_GB';E={[math]::Round($_.Free/1GB,2)}}
Write-Host "================================"