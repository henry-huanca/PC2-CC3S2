#!/usr/bin/env bash
# Uso: ./comparar-historicos.sh <dir_anterior> <dir_actual>
set -euo pipefail

uso(){ echo "Uso: $0 <dir_anterior> <dir_actual>" >&2; exit 1; }
[[ $# -eq 2 ]] || uso

prev_dir="$1"; curr_dir="$2"
prev_csv="$prev_dir/resolucion.csv"
curr_csv="$curr_dir/resolucion.csv"

[[ -f "$prev_csv" ]] || { echo "ERROR: falta $prev_csv" >&2; exit 2; }
[[ -f "$curr_csv" ]] || { echo "ERROR: falta $curr_csv" >&2; exit 2; }

diff_dir="$curr_dir/diff"; mkdir -p "$diff_dir"

TTL_MIN="${TTL_MIN:-60}"
TTL_MAX="${TTL_MAX:-86400}"

echo "Entradas OK."
echo "  anterior: $prev_csv"
echo "  actual  : $curr_csv"
echo "  salida  : $diff_dir/"
echo "  TTL_MIN=$TTL_MIN TTL_MAX=$TTL_MAX"
