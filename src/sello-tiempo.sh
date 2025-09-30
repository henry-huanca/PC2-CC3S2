#!/usr/bin/env bash
# Genera un timestamp UTC limpio para nombrar carpetas de cortes.
# Formato: YYYY-MM-DDTHH-MM-SSZ  (ej: 2025-09-27T04-15-00Z)

set -euo pipefail

# Validación mínima: asegurarnos de que 'date' exista
command -v date >/dev/null 2>&1 || { echo "ERROR: 'date' no está disponible"; exit 1; }

# Imprimir el sello de tiempo (UTC) en el formato acordado
date -u +'%Y-%m-%dT%H-%M-%SZ'
