#!/usr/bin/env bats

setup() {
  rm -rf tmp && mkdir -p tmp/prev tmp/curr
  cat > tmp/prev/resolucion.csv <<CSV
dominio,tipo,valor,ttl,fecha
example.com,A,1.1.1.1,300,2025-01-01T00:00:00Z
CSV
  cat > tmp/curr/resolucion.csv <<CSV
dominio,tipo,valor,ttl,fecha
example.com,A,2.2.2.2,300,2025-01-01T01:00:00Z
CSV
}

teardown() { rm -rf tmp; }

@test "genera altas, bajas, ttl-anomalo e informe con cabeceras" {
  run bash src/comparar-historicos.sh tmp/prev tmp/curr
  [ "$status" -eq 0 ]

  [ -f tmp/curr/diff/altas.csv ]
  [ -f tmp/curr/diff/bajas.csv ]
  [ -f tmp/curr/diff/ttl-anomalo.csv ]
  [ -f tmp/curr/diff/informe.csv ]

  run head -n1 tmp/curr/diff/altas.csv
  [ "$output" = "dominio,tipo,valor" ]

  run head -n1 tmp/curr/diff/bajas.csv
  [ "$output" = "dominio,tipo,valor" ]

  run head -n1 tmp/curr/diff/ttl-anomalo.csv
  [ "$output" = "dominio,tipo,valor,ttl,fecha,motivo" ]

  run head -n1 tmp/curr/diff/informe.csv
  [ "$output" = "dominio,altas,bajas" ]
}
