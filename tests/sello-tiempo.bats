#!/usr/bin/env bats

@test "imprime timestamp UTC con formato correcto" {
  run bash src/sello-tiempo.sh
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}-[0-9]{2}Z$ ]]
}

@test "no tiene espacios ni caracteres raros" {
  run bash src/sello-tiempo.sh
  [ "$status" -eq 0 ]
  [[ "$output" != *" "* ]]
  [[ "$output" =~ ^[0-9TZ-]+$ ]]
}
