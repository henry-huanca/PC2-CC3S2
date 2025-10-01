#!/usr/bin/env bats

DIRECTORIO_RAIZ="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
setup() {
  make clean > /dev/null
}

@test "Comprobando ejecucion correcta del script consulta.sh y creacion de archivos" {
    run ${DIRECTORIO_RAIZ}/src/consulta.sh
    [ "$status" -eq 0 ]
    [ -f "${DIRECTORIO_RAIZ}/out/raw/salida_dig0.txt" ]

}

@test "Probando con dominio incorrecto" {
    run env DOMAINS=estedominionoexiste.xyz,ksdjflksf.com,ireruierisd.sdj ${DIRECTORIO_RAIZ}/src/consulta.sh
    [ "$status" -eq 15 ]  
}
