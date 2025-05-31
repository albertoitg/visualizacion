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

2. Descargar los archivos de matrícula desde el sitio oficial del Ministerio de Educación:  
   https://datosabiertos.mineduc.cl/matricula-en-educacion-superior/  
   Pegar los archivos descargados en la carpeta `data`.

3. Descargar el archivo con los datos del CAE desde el siguiente enlace:  
   https://portal.ingresa.cl/wp-content/uploads/2024/06/CP_2023_HISTORICA_FINAL.txt.zip  
   Extraer el archivo.  
   Asegurarse de guardar o convertir el archivo a formato `.csv`.  
   Mover el archivo `.csv` a la carpeta `data`.

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

Puedes usar cualquier entorno compatible con Jupyter, como JupyterLab, VS Code, o Google Colab.

## Fuentes de datos

- https://datosabiertos.mineduc.cl/matricula-en-educacion-superior/
- https://portal.ingresa.cl