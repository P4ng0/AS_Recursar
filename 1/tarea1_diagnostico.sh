#!/bin/bash
# Tarea 1: Script de diagnóstico inicial - Sistemas Operativos

echo "=========================================="
echo "      DIAGNÓSTICO DE SISTEMA (LINUX)      "
echo "=========================================="

# 1. Nombre del equipo
echo "Nombre del equipo: $(hostname)"

# 2. Dirección IP de la Red Interna (Adaptador enp0s8)
# Extraemos la IP del segmento 192.168.10.x
IP_INTERNA=$(ip addr show enp0s8 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
echo "IP Red Interna:    ${IP_INTERNA:-'No configurada'}"

# 3. Estado del almacenamiento
echo "Espacio en disco (Raíz /):"
df -h / | awk 'NR==2 {print "Total: " $2 " | Usado: " $3 " | Disponible: " $4 " | Uso: " $5}'

# 4. Memoria RAM actual
echo "Memoria RAM:"
free -h | awk '/^Mem:/ {print "Total: " $2 " | Usado: " $3 " | Libre: " $4}'

echo "=========================================="