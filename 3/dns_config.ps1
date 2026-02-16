$NombreZona = "reprobados.com"
$IP_Servidor = "192.168.100.2"

# 1. Instalar solo si falta
Install-WindowsFeature DNS -IncludeManagementTools -ErrorAction SilentlyContinue

# 2. Crear zona solo si no existe
if (!(Get-DnsServerZone -Name $NombreZona -ErrorAction SilentlyContinue)) {
    Add-DnsServerPrimaryZone -Name $NombreZona -ZoneFile "$NombreZona.dns"
}

# 3. Función para agregar registros sin errores si ya existen
function Add-RecordSafely ($Name, $Zone, $IP) {
    if (!(Get-DnsServerResourceRecord -ZoneName $Zone -Name $Name -RRType A -ErrorAction SilentlyContinue)) {
        Add-DnsServerResourceRecordA -Name $Name -ZoneName $Zone -IPv4Address $IP
    }
}

Add-RecordSafely "@" $NombreZona $IP_Servidor
Add-RecordSafely "www" $NombreZona $IP_Servidor
Add-RecordSafely "ns1" $NombreZona $IP_Servidor

Restart-Service DNS