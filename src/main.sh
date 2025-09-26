#!/usr/bin/env bash

set -euo pipefail
trap error ERR

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out"
mkdir -p "${DIRECTORIO_SALIDA}/raw"

error(){
    echo "Ha ocurrido un error en src/main.sh"
    rm -rf "${DIRECTORIO_SALIDA}"
    exit 1
}

# Guardar los dominios objetivo en un arreglo
IFS=',' read -r -a DOMAINS_ARR <<< "$DOMAINS"
i=0
for d in "${DOMAINS_ARR[@]}"; do
    # Guardar la salida de la consulta a cada dominio en archivos
    dig "@${DNS_SERVER}" "${d}" > "${DIRECTORIO_SALIDA}/raw/salida_dig$i.txt"
    ((i+=1))
done

