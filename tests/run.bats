#!/usr/bin/env bats

setup() {
  make clean > /dev/null
}

@test "make run: debe generar el archivo de resolución CSV" {
  # Arrange: aseguramos que el archivo no exista
  [ ! -f "out/csv/resolucion.csv" ]

  # Act: ejecutamos el comando principal
  run make run

  # Assert: verificamos que terminó bien y que el archivo fue creado
  [ "$status" -eq 0 ]
  [ -f "out/csv/resolucion.csv" ]
}
