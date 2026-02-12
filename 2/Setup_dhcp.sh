#!/bin/bash
# 1. Instalación Idempotente
if ! dpkg -s isc-dhcp-server >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y isc-dhcp-server
fi

# 2. Orquestación de Configuración Dinámica
read -p "Nombre descriptivo del Ámbito: " SCOPE_NAME
read -p "Rango inicial (ej. 192.168.100.50): " START_IP
read -p "Rango final (ej. 192.168.100.150): " END_IP
read -p "Puerta de enlace (Gateway): " GATEWAY
read -p "Servidor DNS (IP): " DNS_IP

# Generación del archivo de configuración
cat <<EOF | sudo tee /etc/dhcp/dhcpd.conf
option domain-name "red.local";
option domain-name-servers $DNS_IP;
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.100.0 netmask 255.255.255.0 {
  range $START_IP $END_IP;
  option routers $GATEWAY;
  option subnet-mask 255.255.255.0;
}
EOF

# 3. Validación y Monitoreo
sudo dhcpd -t && sudo systemctl restart isc-dhcp-server
echo "=== ESTADO DEL SERVICIO ==="
sudo systemctl status isc-dhcp-server --no-pager
echo "=== CONCESIONES ACTIVAS ==="
cat /var/lib/dhcp/dhcpd.leases