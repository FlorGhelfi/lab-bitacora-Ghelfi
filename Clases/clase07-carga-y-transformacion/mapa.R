# =============================================================================
# Mapa interactivo de Montevideo con barras de O3 por estación y mes
# Versión R (leaflet + leaflet.minicharts)
# =============================================================================
suppressPackageStartupMessages({
  library(leaflet)
  library(leaflet.minicharts)
  library(htmlwidgets)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(stringr)
  library(lubridate)
})

# --- Configuración -----------------------------------------------------------
CARPETA <- "/Users/floghelfi/Library/CloudStorage/OneDrive-UniversidaddeMontevideo/11AVO SEMESTRE/Introducción a la CD/GitHub/lab-bitacora-Ghelfi/Clases/clase07-carga-y-transformacion"

ARCHIVO_O3 <- file.path(CARPETA, "o3_01_2024_04_2024.csv")
COL_LAT    <- "latitud"
COL_LON    <- "longitud"

# -----------------------------------------------------------------------------
# 1. Datos: media mensual por estación, en formato ancho
# -----------------------------------------------------------------------------
ozono <- read_csv(ARCHIVO_O3, locale = locale(encoding = "UTF-8"), show_col_types = FALSE)

ozono <- ozono %>%
  filter(!is.na(o3))

estaciones <- ozono %>%
  distinct(estacion, lat = .data[[COL_LAT]], lon = .data[[COL_LON]])

# Coordenadas en UTM 21S -> lat/lon (solo si hace falta)
if (max(abs(estaciones$lon)) > 1000) {
  library(sf)
  estaciones <- estaciones %>%
    st_as_sf(coords = c("lon", "lat"), crs = 32721) %>%
    st_transform(4326) %>%
    mutate(lon = st_coordinates(.)[, 1], lat = st_coordinates(.)[, 2]) %>%
    st_drop_geometry()
}

nombres_mes <- c("ene", "feb", "mar", "abr", "may", "jun",
                 "jul", "ago", "sep", "oct", "nov", "dic")

o3_ancho <- ozono %>%
  mutate(mes = nombres_mes[month(fecha)]) %>%
  group_by(estacion, mes) %>%
  summarise(o3_medio = round(mean(o3), 1), .groups = "drop") %>%
  pivot_wider(names_from = mes, values_from = o3_medio) %>%
  left_join(estaciones, by = "estacion")

columnas_mes <- intersect(nombres_mes, names(o3_ancho))
o3_ancho

# Texto del popup: una tabla por estación
popups <- o3_ancho %>%
  rowwise() %>%
  mutate(popup = paste0(
    "<b>", estacion, "</b><br>",
    paste0(columnas_mes, ": ", c_across(all_of(columnas_mes)), " µg/m³", collapse = "<br>")
  )) %>%
  ungroup() %>%
  pull(popup)

# -----------------------------------------------------------------------------
# 2. Mapa
# -----------------------------------------------------------------------------
paleta_meses <- c("#fde725", "#5ec962", "#21918c", "#3b528b")[seq_along(columnas_mes)]

mapa <- leaflet(o3_ancho) %>%
  addTiles() %>%
  setView(lng = -56.17, lat = -34.86, zoom = 12) %>%
  addMinicharts(
    lng = o3_ancho$lon, lat = o3_ancho$lat,
    type = "bar",
    chartdata = o3_ancho[, columnas_mes],
    colorPalette = paleta_meses,
    width = 60, height = 60,
    showLabels = TRUE,
    labelMinSize = 8,
    popup = popupArgs(html = popups),
    legend = TRUE, legendPosition = "topright",
    layerId = o3_ancho$estacion
  ) %>%
  addLabelOnlyMarkers(
    lng = ~lon, lat = ~lat, label = ~estacion,
    labelOptions = labelOptions(noHide = TRUE, direction = "bottom", offset = c(0, 32),
                                textsize = "12px", style = list("font-weight" = "bold"))
  ) %>%
  addControl(
    html = "<b>Ozono en Montevideo, ene–abr 2024</b><br>Media mensual (µg/m³) por estación",
    position = "topleft"
  )

mapa      # en RStudio se abre en el visor

saveWidget(mapa, file.path(CARPETA, "mapa_o3_montevideo_leaflet.html"),
           selfcontained = TRUE)

# -----------------------------------------------------------------------------
# 3. Variante: la misma información con un deslizador temporal
# -----------------------------------------------------------------------------
o3_largo <- ozono %>%
  mutate(mes = month(fecha)) %>%
  group_by(estacion, mes) %>%
  summarise(o3_medio = round(mean(o3), 1), .groups = "drop") %>%
  left_join(estaciones, by = "estacion") %>%
  arrange(mes, estacion)

mapa_tiempo <- leaflet() %>%
  addTiles() %>%
  setView(lng = -56.17, lat = -34.86, zoom = 12) %>%
  addMinicharts(
    lng = o3_largo$lon, lat = o3_largo$lat,
    chartdata = o3_largo$o3_medio,
    time = nombres_mes[o3_largo$mes],
    type = "bar",
    fillColor = "#21918c",
    width = 30, height = 80,
    showLabels = TRUE,
    layerId = o3_largo$estacion
  )

saveWidget(mapa_tiempo, file.path(CARPETA, "mapa_o3_montevideo_leaflet_tiempo.html"),
           selfcontained = TRUE)