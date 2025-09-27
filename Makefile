# Makefile - Sprint 1

export DOMAINS_FILE ?= domains.txt
export DNS_SERVER   ?= 8.8.8.8 
OUT_DIR             := out
DIST_DIR            := dist
BATS_EXEC           := ./tests/bats/bin/bats
TOOLS               := dig awk grep sort

# Evita conflictos con nombres de archivos
.PHONY: help tools build run test clean

help:
	@echo "Uso: make [target]"
	@echo ""
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'


tools:
	@echo "🔎 Verificando dependencias..."
	@for tool in $(TOOLS); do \
		if ! command -v $$tool &> /dev/null; then \
			echo " Error: La herramienta requerida '$$tool' no está instalada."; \
			exit 1; \
		fi \
	done
	@echo "Todas las dependencias están instaladas."


build:
	@echo " Creando directorios de salida..."
	@mkdir -p $(OUT_DIR) $(DIST_DIR)

run: tools build
	@echo "Ejecutando auditoría (servidor DNS: $$DNS_SERVER, archivo: $$DOMAINS_FILE)"
	@bash src/resolver.sh > $(OUT_DIR)/resolucion.csv
	@echo " Resolución completada en $(OUT_DIR)/resolucion.csv"


test:
	@echo " Ejecutando pruebas..."
	@$(BATS_EXEC) tests/*.bats


clean:
	@echo "Limpiando archivos generados..."
	@rm -rf $(OUT_DIR) $(DIST_DIR)