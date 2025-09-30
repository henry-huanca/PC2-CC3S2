#!/usr/bin/env bash
# Uso: ./validar-csv.sh <ruta_csv>
set -euo pipefail
[[ $# -eq 1 ]] || { echo "Uso: $0 <ruta_csv>" >&2; exit 1; }
csv="$1"
[[ -f "$csv" ]] || { echo "ERROR: falta archivo: $csv" >&2; exit 2; }

expected="dominio,tipo,valor,ttl,fecha"
actual="$(head -n1 "$csv" || true)"

if [[ "$actual" != "$expected" ]]; then
  echo "ERROR: cabecera inválida. Esperada: $expected ; Actual: $actual" >&2
  exit 3
fi

echo "OK: cabecera válida en $csv"
