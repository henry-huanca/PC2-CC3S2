#!/usr/bin/env bats

setup() {
  rm -rf tmp && mkdir -p tmp/prev tmp/curr
  cat > tmp/prev/resolucion.csv <<CSV
dominio,tipo,valor,ttl,fecha
old.com,A,9.9.9.9,300,2025-01-01T00:00:00Z
stable.com,A,1.1.1.1,300,2025-01-01T00:00:00Z
CSV
  cat > tmp/curr/resolucion.csv <<CSV
dominio,tipo,valor,ttl,fecha
new.com,A,8.8.8.8,300,2025-01-01T01:00:00Z
stable.com,A,1.1.1.1,30,2025-01-01T01:00:00Z
CSV
}

teardown() { rm -rf tmp; }

@test "detecta altas, bajas y ttl-anomalo con umbrales" {
  TTL_MIN=60 TTL_MAX=86400 run bash src/comparar-historicos.sh tmp/prev tmp/curr
  [ "$status" -eq 0 ]

  run tail -n +2 tmp/curr/diff/altas.csv
  [[ "$output" == *"new.com,A,8.8.8.8"* ]]

  run tail -n +2 tmp/curr/diff/bajas.csv
  [[ "$output" == *"old.com,A,9.9.9.9"* ]]

  run tail -n +2 tmp/curr/diff/ttl-anomalo.csv
  [[ "$output" == *"stable.com,A,1.1.1.1,30,2025-01-01T01:00:00Z,ttl<60"* ]]

  run grep -E "^new.com," tmp/curr/diff/informe.csv
  [[ "$output" == "new.com,1,0" ]]

  run grep -E "^old.com," tmp/curr/diff/informe.csv
  [[ "$output" == "old.com,0,1" ]]
}
