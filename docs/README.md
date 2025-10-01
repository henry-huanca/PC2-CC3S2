# Proyecto: Auditor ligero de DNS con caché de Make

Este proyecto implementa un auditor de DNS que resuelve dominios, detecta cambios en los registros (IPs nuevas o perdidas) para un conjunto de dominios.

## Requisitos
* `bash`
* `make`
* `dig`, `awk`, `grep`, `sort` (valida con `make tools`)
* Se hace uso de las pruebas de bats-core para lo cual se gestiono el submmodulo de bats.

1.  **clonacion de repositorio:**
Para clonar el proyecto junto con el repositorio de pruebas
```bash
    git clone --recurse-submodules https://github.com/henry-huanca/PC2-CC3S2.git
```
2.  **Inicializacion manual de submodulos**
Si ya clonaste el repositorio sin el submodulo la carpeta tests/bats aparecera vacia. para descargar e inicializar el modulo de pruebas se ejecuta lo siguiente:
```bash
git submodule init
git submodule update
```
3.  **Instalacion de dig:**
```bash
sudo apt install dnsutils
```
4.  **cambiar formato a LF y verificacion de bats:**
Instalar la dependencia dos2unix
```bash
sudo apt install dos2unix -y
```
Convierte el archivo principal bats a formato Unix (LF)
```bash
dos2unix tests/bats/bin/bats
```
 Convierte todos los archivos dentro de tests/bats a formato Unix (LF)
 ```bash
find tests/bats -type f -exec dos2unix {} +
```
## Uso Rápido

1.  **Validar Dependencias:**
    ```bash
    make tools
    ```

2.  **Ejecutar la Auditoría:**
    ```bash
    DOMAINS="google.com,uni.edu.pe" DNS_SERVER=1.1.1.1 make run
    ```
    Los resultados se generan en `out/resolucion.csv`.

3.  **Ejecutar Pruebas:**
    ```bash
    make test
    ```
4.  **Generar directorios de salida:**
    ```bash
    make build
    ```
5.  **Limpiar archivos generados:**
    ```bash
    make clean
    ```

## Metodologia AAA/RGR

1. **Probar prueba que falla**
    ```bash
    make red
    ```
2. **Probar que todas las pruebas estan en verde en red**
```bash
    DOMAINS="google.com,uni.edu.pe" DNS_SERVER=1.1.1.1 make red

 ```
3. **Probar que todas las pruebas estan en verde**
```bash
    DOMAINS="google.com,uni.edu.pe" DNS_SERVER=1.1.1.1 make green
```
4. **Probar prueba despues de limpiar**
```bash
    DOMAINS="google.com,uni.edu.pe" DNS_SERVER=1.1.1.1 make refactor
```
5. **Generar archivos csv en un determinado tiempo**
```bash
    DOMAINS="google.com,uni.edu.pe" DNS_SERVER=1.1.1.1 make snapshot
```
4. **Comparar csv originados a traves de make snapshot**
```bash
    make Compare
```
## Configuración (Variables de Entorno)

La configuración se gestiona exclusivamente a través de variables de entorno, siguiendo el principio III de 12-Factor.

| Variable       | Efecto Observable                                          | Valor por Defecto |
|----------------|------------------------------------------------------------|-------------------|
| `DNS_SERVER`   | Servidor DNS a utilizar para las consultas (`dig,grep,awk,sort`).   | (System default)  |
| `DOMAINS` | Ruta al archivo con la lista de dominios a auditar.        |Lista de dominios separadas por comas     |

