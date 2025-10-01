# Makefile - Sprint 2

OUT_DIR             := out
RAW_DIR         	:= $(OUT_DIR)/raw
CSV_DIR         	:= $(OUT_DIR)/csv
FINAL_CSV       	:= $(CSV_DIR)/resolucion.csv
BATS_EXEC           := ./tests/bats/bin/bats
TOOLS               := dig awk grep sort

CONSULTA_FLAG   := $(RAW_DIR)/.consulta
COMPARAR_SCRIPT := src/comparar-historicos.sh

# Evita conflictos con nombres de archivos
.PHONY: help tools build run test clean rgr red green refactor
all: $(FINAL_CSV)

help:
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'


tools: ## verifica que las dependencias esten instaladas
	@echo "Verificando dependencias..."
	@for tool in $(TOOLS); do \
		if ! command -v $$tool >/dev/null 2>&1; then \
			echo " Error: La herramienta requerida '$$tool' no está instalada."; \
			exit 1; \
		fi \
	done
	@echo "Todas las dependencias están instaladas."


build: ## prepara los directorios de trabajo
	@echo " Creando directorios de salida..."
	@mkdir -p $(RAW_DIR) $(CSV_DIR)

run: $(FINAL_CSV)
$(FINAL_CSV): $(CONSULTA_FLAG) src/actualizador-csv.sh
	@echo "generando csv final"
	@bash src/actualizador-csv.sh
	@echo "archivo csv actualizado"
$(CONSULTA_FLAG): src/consulta.sh
	@echo "ejecutando consultas DNS"
	@rm -f $(RAW_DIR)/*
	@bash src/consulta.sh
	@touch $(CONSULTA_FLAG)


validar: $(FINAL_CSV)
	@echo "valida cabecera del csv"
	@bash src/validar-csv.sh $(FINAL_CSV)

snapshot: tools
	@timestamp=$$(src/sello-tiempo.sh); \
	echo "se creo un snapshot en timestamp"; \
	snapshot_dir=$(OUT_DIR)/$$timestamp; \
	mkdir -p $$snapshot_dir/csv $$snapshot_dir/raw; \
	echo "consultar dominios"; \
	DOMAINS=$(DOMAINS) DNS_SERVER=$(DNS_SERVER); \
	src/consulta_snapshot.sh $$snapshot_dir; \
	echo "generar archivo csv"; \
	src/actualizador-csv-snapshot.sh $$snapshot_dir; \
	echo "validar csv"; \
	src/validar-csv.sh $$snapshot_dir/csv/resolucion.csv; \
	echo "snapshot completado"

compare:
	@echo "comparar los snapshots"
	@if [ $$(ls -1q $(OUT_DIR) | wc -l) -lt 2 ]; then \
		echo "se necesita por lo menos 2 snapshot"; \
	fi

	@latest=$$(ls -1 $(OUT_DIR) | tail -n 1); \
	previous=$$(ls -1 $(OUT_DIR) | tail -n 2 | head -n 1); \
	echo "Anterior: $$previous"; \
	echo "actual: $$latest"; \
	src/comparar-historicos.sh $(OUT_DIR)/$$previous/csv $(OUT_DIR)/$$latest/csv



test: ## Ejecuta la pruebas bats de forma reproducible
	@echo " Ejecutando pruebas..."
	@$(BATS_EXEC) tests/*.bats


clean: ## Elimina los archivos y directorios generados
	@echo "Limpiando archivos generados..."
	@rm -rf $(OUT_DIR) $(DIST_DIR)
	@rm -rf dist/

pack: clean

	@echo "empaquetando el proyecto"
	@mkdir -p dist/
	@tar -czvf dist/auditor-dns-v1.0.0.tar.gz src/ docs/ tests/ Makefile

red: ## asegurar que falle el test
	@if $(BATS_EXEC) tests/*.bats; then\
		echo "Todas las pruebas estan en verde, escribe primero una prueba que falle RED "; exit 1; \
	else \
		echo  "Estas en RED, implementa para pasar, luego haz VERDE"; \
	fi

green: ## ejecuta los test hasta que pasen	
	@$(BATS_EXEC) tests/*.bats && echo "refactoriza de manera segura"

refactor: ##ejecutar test tras refactor
	@$(BATS_EXEC) tests/*.bats && echo "despues de refactorizar las pruebas siguen en verde"