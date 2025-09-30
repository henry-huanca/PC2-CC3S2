#!/usr/bin/env bash

set -euo pipefail
trap error ERR

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/raw"
mkdir -p "${DIRECTORIO_SALIDA}"

error(){
    echo "Ha ocurrido un error en src/main.sh"
    rm -rf "${DIRECTORIO_SALIDA}"
    exit 10
}
# Funcion para extraer el dominio_raiz
get_dominio_raiz() {
    # Lista de TLDs compuestos comunes
    local tlds_compuestos=("co.uk" "com.br" "org.br" "gov.br" "com.au" "org.au" "edu.au" "com.co" "org.co" "edu.co" "com.mx" "org.mx" "edu.mx" "com.ar" "org.ar" "com.pe" "org.pe" "edu.pe" "com.sa" "org.sa" "edu.sa" "com.sg" "org.sg" "gov.sg" "com.tw" "org.tw" "edu.tw" "com.hk" "org.hk" "edu.hk")
    local dom=$1
    # Verificar si el dominio tiene un TLD compuesto, si contiene, entonces devuelve el SLD+TLD
    for tld in "${tlds_compuestos[@]}"; do
        if [[ "$dom" == *$tld ]]; then
            local sld_tld=$(echo "$dom" | sed -E "s/^[^.]+\.([^.]+\.$tld)$/\1/")
            echo "$sld_tld"
            return
        fi
    done

    # Si no tiene TLD compuesto, se capturan los dos ultimos elementos
    local root_domain=$(echo "$dom" | sed 's/^[^.]*\.\([^.]*\.[^.]*\)$/\1/')
    echo "$root_domain"
}
# Guardar los dominios objetivo en un arreglo
IFS=',' read -r -a DOMAINS_ARR <<< "$DOMAINS"
i=0
for d in "${DOMAINS_ARR[@]}"; do
    # Guardar la salida de la consulta a cada dominio en archivos
    ts=$(date -u +%FT%TZ) # Timestamp
    dominio_raiz=$(get_dominio_raiz $d)
    NS_SERVER=$(dig @"$DNS_SERVER" "$dominio_raiz" NS +short | head -n1 | sed 's/\.$//') # Servidor autoritativo
    dig "@${NS_SERVER}" "${d}" +norecurse > "${DIRECTORIO_SALIDA}/salida_dig$i.txt" # Consulta a servidor autoritativo
    echo $ts >> "${DIRECTORIO_SALIDA}/salida_dig$i.txt"
    ((i+=1))
done

