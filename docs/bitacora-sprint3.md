# Bitácora – Sprint 3

## Objetivos de este sprint
-Integrar los scripts de comparacion de historicos en el makefile \
-Implementar un empaquetador reproducible make pack para la entrega final del proyecto

## Desarrollo de snapshot

-Para realizar la comparacion de los historicos se implemento en makefile snapshot que va a permitir guardar el historial en diferentes cortes de tiempo

```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ DNS_SERVER="8.8.8.8" DOMAINS="google.com,github.com" make snapshot
Verificando dependencias...
Todas las dependencias están instaladas.
se creo un snapshot en timestamp
consultar dominios
generar archivo csv
validar csv
OK: cabecera válida en out/2025-10-01T01-53-50Z/csv/resolucion.csv
snapshot completado
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ DNS_SERVER="8.8.8.8" DOMAINS="google.com,github.com" make snapshot
Verificando dependencias...
Todas las dependencias están instaladas.
se creo un snapshot en timestamp
consultar dominios
generar archivo csv
validar csv
OK: cabecera válida en out/2025-10-01T01-54-00Z/csv/resolucion.csv
snapshot completado
```
-Para dicha comparacion se hace uso de make compare que va a tomar los dos ultimos snapshots y compararlos

```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ make compare
comparar los snapshots
Anterior: 2025-10-01T01-53-50Z
actual: 2025-10-01T01-54-00Z
OK: diffs generados en out/2025-10-01T01-54-00Z/csv/diff
Archivos:
altas.csv
bajas.csv
informe.csv
ttl-anomalo.csv
```
## Empaquetado de carpetas
-Se empaqueto las carpetas necesarias para sacar adelante el proyecto
```bash
henry@LAPTOP-J58LHNLD:/mnt/d/DESARROLLO-SOFTWARE/PC2-CC3S2$ make pack
Limpiando archivos generados...
empaquetando el proyecto
src/
src/.gitkeep
src/actualizador-csv-snapshot.sh
src/actualizador-csv.sh
src/comparar-historicos.sh
src/consulta.sh
src/consulta_snapshot.sh
src/sello-tiempo.sh
src/validar-csv.sh
docs/
docs/.gitkeep
docs/bitacora-sprint-1.md
docs/bitacora-sprint3.md
docs/bitacora_sprint1.md
docs/bitacora_sprint2.md
docs/contrato-salidas.md
docs/README.md
tests/
tests/.gitkeep
tests/bats/
tests/bats/.codespellrc
tests/bats/.devcontainer/
tests/bats/.devcontainer/devcontainer.json
tests/bats/.devcontainer/Dockerfile
tests/bats/.editorconfig
tests/bats/.git
tests/bats/.gitattributes
tests/bats/.github/
tests/bats/.github/dependabot.yml
tests/bats/.github/ISSUE_TEMPLATE/
tests/bats/.github/ISSUE_TEMPLATE/bug_report.md
tests/bats/.github/ISSUE_TEMPLATE/feature_request.md
tests/bats/.github/workflows/
tests/bats/.github/workflows/check_pr_label.sh
tests/bats/.github/workflows/codespell.yml
tests/bats/.github/workflows/dependency-review.yml
```
- se realizo el test para verificar que se creo el directorio tar
```bash
pack.bats
 ✓ make pack: generar el tar en la carpeta dist
 ✓ make pack:debe contener los archivos correctos
```