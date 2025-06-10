import unicodedata
import pandas as pd
import xml.etree.ElementTree as et
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import numpy as np
from matplotlib.colors import BoundaryNorm
from mapclassify import FisherJenks

def normalizar_sin_tildes(texto):
    """
    Convierte un texto a mayúsculas, eliminando tildes,
    pero manteniendo caracteres especiales como ñ, Ñ, ü, Ü, ç, etc.
    """
    # Normaliza en forma NFD (separa letras y tildes)
    texto_normalizado = unicodedata.normalize('NFD', texto)
    
    # Filtra las marcas diacríticas (tildes), pero conserva la virgulilla (~) de la ñ y la diéresis (¨) de la ü
    texto_sin_tildes = ''.join(
        c for c in texto_normalizado 
        if unicodedata.category(c) != 'Mn' or c in ['\u0303', '\u0308']  # ~ y ¨
    )
    
    # Vuelve a normalizar en NFC y convierte a mayúsculas
    return unicodedata.normalize('NFC', texto_sin_tildes).upper()



data = pd.read_csv("consolidado_comuna_mayor_20.csv")


#Comunas_de_Santiago.svg

# colormap = plt.cm.coolwarm
# norm = plt.Normalize(vmin=0.20, vmax=0.46)
# data['color_hex'] = data['porcentaje_desertores'].apply(lambda x: mcolors.to_hex(colormap(norm(x))))

# 2. Calcular límites de cuartiles (0%, 25%, 50%, 75%, 100%)
quantile_bounds = np.percentile(data['porcentaje_desertores'], [0, 20, 40, 60, 80, 100])

# 4. Definir colormap y normalizador uniforme y por cuantiles
colormap = plt.cm.OrRd

norm = plt.Normalize(vmin=0.172, vmax=0.538)
data['color_hex'] = data['porcentaje_desertores'].apply(lambda x: mcolors.to_hex(colormap(norm(x))))

norm = BoundaryNorm(quantile_bounds, ncolors=colormap.N)
data['color_hex_quantiles'] = data['porcentaje_desertores'].apply(
    lambda x: mcolors.to_hex(colormap(norm(x)))
)

# Clasificación Fisher-Jenks
fisher_jenks = FisherJenks(data['porcentaje_desertores'], k=7)
norm = BoundaryNorm(fisher_jenks.bins, ncolors=colormap.N)

# Asignar color
data['color_hex_fisher'] = data['porcentaje_desertores'].apply(
    lambda x: mcolors.to_hex(colormap(norm(x)))
)

tree = et.parse("Comunas_de_Santiago.svg")
root = tree.getroot()

modelo = ["color_hex", "color_hex_quantiles", "color_hex_fisher"]
modelo_seleccionado = 3

ns = {'svg': 'http://www.w3.org/2000/svg'}

for elem in root.findall('.//svg:path', ns):

    style = elem.get('style')
    id = elem.get("id")
    if id is None:
        continue

    id_df = normalizar_sin_tildes(id)

    try:
        color = data.loc[data["comuna"] == id_df, modelo[modelo_seleccionado - 1]].values[0]
    except Exception:
        color = "url(#hatch)"

    elem.set("style",f"fill:{color};fill-opacity:1;fill-rule:evenodd;stroke:black;stroke-width:0.2;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1")

tree.write(f"mapa_heatmap_{modelo[modelo_seleccionado - 1]}.svg")
