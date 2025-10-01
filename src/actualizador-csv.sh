#!/usr/bin/env bash

set -euo pipefail
trap error ERR

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/csv"
mkdir -p "${DIRECTORIO_SALIDA}"

error(){
    echo "Ha ocurrido un error en src/actualiza-csv.sh"
    rm -rf "${DIRECTORIO_SALIDA}"
    exit 20
}
if [[ ! -f "${DIRECTORIO_SALIDA}/resolucion.csv" ]]; then # Si el archivo no existe
    # Crear archivo y agregar cabecera
    echo "dominio,tipo,valor,ttl,fecha" > "${DIRECTORIO_SALIDA}/resolucion.csv"
fi
# Cuenta el numero de archivos de salida
n=$(ls "${DIRECTORIO_RAIZ}/out/raw" | grep -c "salida_dig*")
((n-=1))
for i in $(seq 0 $n); do
    ts=$(tail -n 1 "${DIRECTORIO_RAIZ}/out/raw/salida_dig${i}.txt") # Extrae el timestamp
    # Extraer las respuestas del archivo, filtrar y agregar timestamp. Luego se agregan como nuevas filas al archivo
    awk '/ANSWER SECTION/,/^$/' "${DIRECTORIO_RAIZ}/out/raw/salida_dig${i}.txt" | tail -n +2 | awk -v OFS=, -v ts="$ts" 'NF{print $1,$4,$5,$2,ts}' >> "${DIRECTORIO_SALIDA}/resolucion.csv"
done