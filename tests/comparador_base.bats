#!/usr/bin/env bats

setup(){ mkdir -p tmp/prev tmp/curr; }
teardown(){ rm -rf tmp; }

@test "muestra uso cuando faltan argumentos" {
  run bash src/comparar-historicos.sh
  [ "$status" -ne 0 ]
  [[ "$output" == *"Uso:"* ]]
}

@test "falla si no existen los resolucion.csv" {
  run bash src/comparar-historicos.sh tmp/prev tmp/curr
  [ "$status" -eq 2 ]
  [[ "$output" == *"ERROR: falta"* ]]
}
