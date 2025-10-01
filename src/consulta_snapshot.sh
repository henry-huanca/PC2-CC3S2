#!/usr/bin/env bash

set -euo pipefail
[[ $# -eq 1 ]] || { echo "Uso: $0 <directorio_snapshot>" >&2; exit 1; }
DIRECTORIO_SALIDA="$1/raw"
mkdir -p "${DIRECTORIO_SALIDA}"

trap 'echo "Ha ocurrido un error"' ERR

# Guardar los dominios objetivo en un arreglo
IFS=',' read -r -a DOMAINS_ARR <<< "$DOMAINS"
i=0
for d in "${DOMAINS_ARR[@]}"; do
    # Guardar la salida de la consulta a cada dominio en archivos
    ts=$(date -u +%FT%TZ) # Timestamp
    NS_SERVER=$(dig @"$DNS_SERVER" "$d" NS +short | head -n1 | sed 's/\.$//') # Servidor autoritativo
    dig "@${NS_SERVER}" "${d}" +norecurse > "${DIRECTORIO_SALIDA}/salida_dig$i.txt" # Consulta a servidor autoritativo
    echo $ts >> "${DIRECTORIO_SALIDA}/salida_dig$i.txt"
    ((i+=1))
done

