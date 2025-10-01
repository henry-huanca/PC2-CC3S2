# Bitácora – Sprint 2

##  Objetivos de este sprint

-Implementar un cache incremental en el makefile \
-Implementar el flujo de trabajo con RED-GREEN-REFACTOR

## 1. Verificación de cache incremental
se ejecuta y se crea los archivos resolucion.csv y las salidas dig
```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ time DOMAINS="google.com,github.com,uni.pe" DNS_SERVER=1.1.1.1 make run
ejecutando consultas DNS
generando csv final
archivo csv actualizado

real    0m3.364s
user    0m0.078s
sys     0m0.270s
```
Se vuelve a a inicializar el programa y se verifica que ya tiene los archivos por lo que el tiempo de inicio se acelera considerablemente
```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ time DOMAINS="google.com,github.com,uni.pe" DNS_SERVER=1.1.1.1 make run
make: Nothing to be done for 'run'.

real    0m0.039s
user    0m0.002s
sys     0m0.006s
```
## 2. Metodologia RGR

Se verifica que al menos uno de los tests falla por lo que se pone el estado en rojo

```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ make red
run.bats
 ✗ make run: debe generar el archivo de resolución CSV
   (in test file tests/run.bats, line 15)
     `[ "$status" -eq 0 ]' failed

1 test, 1 failure

Estas en RED, implementa para pasar, luego haz VERDE
```
Se arregla el error y se verifica que pase con green
```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ make green
run.bats
 ✓ make run: debe generar el archivo de resolución CSV

1 test, 0 failures

refactoriza de manera segura
```
Se limpia el trabajo y se refactoriza
```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ make refactor
run.bats
 ✓ make run: debe generar el archivo de resolución CSV

1 test, 0 failures

despues de refactorizar las pruebas siguen en verde
```