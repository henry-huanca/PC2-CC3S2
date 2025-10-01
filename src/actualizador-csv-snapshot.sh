#!/usr/bin/env bash

set -euo pipefail
trap error ERR

error(){
    echo "Ha ocurrido un error en src/actualizador-csv-snapshot.sh"
    exit 1
}

if [[ $# -eq 1 ]]; then
    DIRECTORIO_SALIDA="$1/csv"
    DIRECTORIO_RAW="$1/raw"
else
    DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
    DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/csv"
    DIRECTORIO_RAW="${DIRECTORIO_RAIZ}/out/raw"
fi

mkdir -p "$DIRECTORIO_SALIDA"

CSV_FILE="${DIRECTORIO_SALIDA}/resolucion.csv"


if [[ ! -f "$CSV_FILE" ]]; then
    echo "dominio,tipo,valor,ttl,fecha" > "$CSV_FILE"
fi


shopt -s nullglob
raw_files=("${DIRECTORIO_RAW}"/salida_dig*.txt)

if [[ ${#raw_files[@]} -eq 0 ]]; then
    echo "ERROR: no se encontraron archivos en ${DIRECTORIO_RAW}" >&2
    exit 2
fi


for raw in "${raw_files[@]}"; do
    ts=$(tail -n 1 "$raw") # Extrae timestamp
    awk '/ANSWER SECTION/,/^$/' "$raw" \
        | tail -n +2 \
        | awk -v OFS=, -v ts="$ts" 'NF{print $1,$4,$5,$2,ts}' \
        >> "$CSV_FILE"
done
