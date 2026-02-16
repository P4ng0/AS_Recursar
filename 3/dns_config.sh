#!/bin/bash

# 1. Definición de variables

IP_SERVIDOR="192.168.100.1"

# 2. Instalación de paquetes
sudo apt update && sudo apt install bind9 bind9utils dos2unix -y

# 3. Configuración de named.conf.local
cat <<EOF | sudo tee /etc/bind/named.conf.local
zone "reprobados.com" {
    type master;
    file "/var/cache/bind/db.reprobados.com";
};
EOF

# 4. Creación del archivo de zona 

cat <<EOF | sudo tee /var/cache/bind/db.reprobados.com
\$TTL 86400
@   IN  SOA ns1.reprobados.com. admin.reprobados.com. (
        $(date +%Y%m%d)02 ; Serial actualizado
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        86400 )    ; Minimum TTL

@   IN  NS  ns1.reprobados.com.
ns1 IN  A   $IP_SERVIDOR
@   IN  A   $IP_SERVIDOR
www IN  A   $IP_SERVIDOR
EOF


sudo chown bind:bind /var/cache/bind/db.reprobados.com
sudo chmod 644 /var/cache/bind/db.reprobados.com
sudo dos2unix /etc/bind/named.conf.local
sudo dos2unix /var/cache/bind/db.reprobados.com

echo "--- Verificando sintaxis del servidor ---"
sudo named-checkconf -z
sudo systemctl restart bind9

echo "Configuración exitosa. Prueba en Lubuntu con 'ping www.reprobados.com'"