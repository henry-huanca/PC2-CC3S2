#!/usr/bin/env bats

@test "exige argumento" {
  run bash src/validar-csv.sh
  [ "$status" -ne 0 ]
  [[ "$output" == *"Uso:"* ]]
}

@test "falla si no existe archivo" {
  run bash src/validar-csv.sh no-existe.csv
  [ "$status" -eq 2 ]
  [[ "$output" == *"falta archivo"* ]]
}
