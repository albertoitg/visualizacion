# Análisis de Matrícula y Crédito con Aval del Estado (CAE) en Chile

Este proyecto permite analizar datos de matrícula en educación superior y del Crédito con Aval del Estado (CAE), usando Python en un entorno interactivo Jupyter Notebook.

## Instalación

### 1. Instalar `uv`

Ejecuta el siguiente comando en PowerShell para instalar el gestor de paquetes `uv`:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

## Preparación de los datos

1. Crear una carpeta llamada `data` en la raíz del proyecto.

2. Descargar los archivos zip de:
   https://drive.google.com/drive/folders/10ybeGb5neRgUZtUwErHyEbSa9IPo8Vlb?usp=sharing
   Descomprimir los archivos.
   Mover los archivos `.csv` a la carpeta `data`.

## Instalación de dependencias

Ejecutar en la raíz del proyecto:

```bash
uv sync
```

Este comando instalará automáticamente todas las dependencias necesarias del proyecto.

## Ejecución del proyecto

Abrir y ejecutar el archivo Jupyter Notebook:

```bash
proyecto.ipynb
```

Puedes ejecutarlo directamente de VS Code o abrirlo desde el navegador con:

```bash
uv run jupyter notebook
```


## Fuentes de datos

- https://datosabiertos.mineduc.cl/matricula-en-educacion-superior/
- https://portal.ingresa.cl