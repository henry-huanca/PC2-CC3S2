#!/usr/bin/env bats
PACKAGE_NAME="dist/auditor-dns-v1.0.0.tar.gz"
setup(){
    make clean > /dev/null
}

@test "make pack: generar el tar en la carpeta dist" {
    [ ! -f "$PACKAGE_NAME" ]

    run make pack

    [ "$status" -eq 0 ]
    [ -f "$PACKAGE_NAME" ]
}

@test "make pack:debe contener los archivos correctos" {

    run make pack
    [ "$status" -eq 0 ]

    echo "$output" | grep -q "src/"
    echo "$output" | grep -q "docs/"
    echo "$output" | grep -q "tests/"
    echo "$output" | grep -q "Makefile"
}