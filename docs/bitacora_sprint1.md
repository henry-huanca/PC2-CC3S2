# Bitácora – Sprint 1

## 📌 Objetivos de este sprint

- Implementar Makefile mínimo con targets básicos (`tools`, `build`, `run`, `test`, `clean`).
- Escribir primera prueba Bats con metodología AAA/RGR.
- Documentar variables de entorno en README.

---

## 📌 Comandos ejecutados

### 1. Verificación de dependencias

```bash
make tools
    Verificando dependencias...
    Todas las dependencias están instaladas.

make clean
Limpiando archivos generados...

make build
Creando directorios de salida...
make help
Targets disponibles:
  build      prepara los directorios de trabajo
  clean      Elimina los archivos y directorios generados
  run        ejecuta el flujo principal del auditor DNS
  test       Ejecuta la pruebas bats de forma reproducible
  tools      verifica que las dependencias esten instaladas

make run
Ejecutando auditoría (servidor DNS: 8.8.8.8 , archivo: domains.txt)
/bin/sh: 1: cannot create out/resolucion.csv: Directory nonexistent
make: *** [Makefile:36: run] Error 2

make test
    Ejecutando pruebas...
    run.bats
    ✗ make run: debe generar el archivo de resolución CSV
    (in test file tests/run.bats, line 15)
        `[ "$status" -eq 0 ]' failed

        1 test, 1 failure
        make: *** [Makefile:42: test] Error 1

```
## Metodologia RGR

    se implemento dentro de la carpeta test la prueba run.bats el cual evalua si el archivo out/resolucion.csv fue generado exitosamente.
    En nuestro caso generamos la prueba inicial en rojo al no existir por el momento el archivo que lo genera