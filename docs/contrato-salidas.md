# Contrato de salidas – Módulo de históricos (Emhir)

## Estructura de cortes
- Cada corte en: out/<timestamp>/
- timestamp = YYYY-MM-DDTHH-MM-SSZ (UTC), generado por src/sello-tiempo.sh

## Entrada esperada (Lo que debe producir Sergio)
Archivo: out/<timestamp>/resolucion.csv  
Cabecera exacta:
dominio,tipo,valor,ttl,fecha

## Variables de entorno (usadas por Emhir)
- TTL_MIN (default 60)
- TTL_MAX (default 86400)

## Salidas al comparar <ts_prev> vs <ts_curr> (se crearán en out/<ts_curr>/diff/)
- altas.csv        : dominio,tipo,valor
- bajas.csv        : dominio,tipo,valor
- ttl-anomalo.csv  : dominio,tipo,valor,ttl,fecha,motivo
- informe.csv      : consolidado por dominio (definiciones al implementar)

## Validaciones rápidas (cuando se creen los  archivos)
- Cabecera CSV: bash src/validar-csv.sh out/<ts>/resolucion.csv
