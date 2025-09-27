#!/usr/bin/env bash
# Comparador de históricos DNS
# Uso: ./comparar-historicos.sh <dir_anterior> <dir_actual>
# Salidas en: <dir_actual>/diff/{altas.csv,bajas.csv,ttl-anomalo.csv,informe.csv}

set -euo pipefail

uso(){ echo "Uso: $0 <dir_anterior> <dir_actual>" >&2; exit 1; }
[[ $# -eq 2 ]] || uso

prev_dir="$1"
curr_dir="$2"

prev_csv="$prev_dir/resolucion.csv"
curr_csv="$curr_dir/resolucion.csv"
[[ -f "$prev_csv" ]] || { echo "ERROR: falta $prev_csv" >&2; exit 2; }
[[ -f "$curr_csv" ]] || { echo "ERROR: falta $curr_csv" >&2; exit 2; }

diff_dir="$curr_dir/diff"
mkdir -p "$diff_dir"

# Umbrales de TTL (configurables por entorno)
TTL_MIN="${TTL_MIN:-60}"
TTL_MAX="${TTL_MAX:-86400}"

# --- Preparar sets dominio,tipo,valor (ordenados y únicos) ---
prev_set="$diff_dir/.prev_set"
curr_set="$diff_dir/.curr_set"

awk -F',' 'NR>1 {print $1","$2","$3}' "$prev_csv" | sort -u > "$prev_set"
awk -F',' 'NR>1 {print $1","$2","$3}' "$curr_csv" | sort -u > "$curr_set"

# --- ALTAS: en actual y no en anterior ---
{
  echo "dominio,tipo,valor"
  comm -13 "$prev_set" "$curr_set"
} > "$diff_dir/altas.csv"

# --- BAJAS: en anterior y no en actual ---
{
  echo "dominio,tipo,valor"
  comm -23 "$prev_set" "$curr_set"
} > "$diff_dir/bajas.csv"

# --- TTL ANÓMALO: filas del CSV actual con TTL fuera de rango ---
{
  echo "dominio,tipo,valor,ttl,fecha,motivo"
  awk -F',' -v lo="$TTL_MIN" -v hi="$TTL_MAX" '
    NR>1 {
      ttl=$4+0
      if (ttl < lo) { print $1","$2","$3","$4","$5",ttl<"lo }
      else if (ttl > hi) { print $1","$2","$3","$4","$5",ttl>"hi }
    }
  ' "$curr_csv"
} > "$diff_dir/ttl-anomalo.csv"

# --- INFORME CONSOLIDADO por dominio (conteo de altas/bajas) ---
# Combina conteos por dominio en altas/bajas
alt_tmp="$diff_dir/.alt_dom"
baj_tmp="$diff_dir/.baj_dom"

awk -F',' 'NR>1 {c[$1]++} END{for(d in c) print d","c[d]}' "$diff_dir/altas.csv" > "$alt_tmp" || true
awk -F',' 'NR>1 {c[$1]++} END{for(d in c) print d","c[d]}' "$diff_dir/bajas.csv" > "$baj_tmp" || true

{
  echo "dominio,altas,bajas"
  awk -F',' '
    FNR==NR { altas[$1]=$2; next }
    { bajas[$1]=$2 }
    END{
      # dominios presentes en altas
      for (d in altas) {
        bz = (d in bajas) ? bajas[d] : 0
        print d","altas[d]","bz
        seen[d]=1
      }
      # dominios solo en bajas
      for (d in bajas) if (!(d in seen)) {
        print d",0,"bajas[d]
      }
    }
  ' "$alt_tmp" "$baj_tmp" | sort
} > "$diff_dir/informe.csv"

# Limpieza de temporales
rm -f "$prev_set" "$curr_set" "$alt_tmp" "$baj_tmp"

echo "OK: diffs generados en $diff_dir"
echo "Archivos:"
ls -1 "$diff_dir"
