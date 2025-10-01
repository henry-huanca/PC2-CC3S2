# Bitácora Sprint 1 – Emhir

## Avances de hoy
- src/sello-tiempo.sh (timestamp UTC limpio) + tests Bats.
- src/comparar-historicos.sh (esqueleto: valida args/archivos, TTL_MIN/MAX).
- tests/comparador_base.bats (uso y errores).
- src/validar-csv.sh (cabecera) + tests de uso/errores.
- docs/contrato-salidas.md (estructura, cabecera, variables, salidas).

## Comandos ejecutados (muestra)
- bats tests/sello-tiempo.bats
```bash
sello-tiempo.bats
 ✓ imprime timestamp UTC con formato correcto
 ✓ no tiene espacios ni caracteres raros
```
- bats tests/comparador_base.bats
```bash
comparador_base.bats
 ✓ muestra uso cuando faltan argumentos
 ✓ falla si no existen los resolucion.csv
 ```
- bats tests/validar_csv_base.bats
```bash
validar_csv_base.bats
 ✓ exige argumento
 ✓ falla si no existe archivo
```
## Pendientes (bloqueados hasta que Sergio genere CSV)
- Lógica de diffs (altas/bajas/ttl-anómalo) e informe.csv
- Pruebas Bats con datos reales
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