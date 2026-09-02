# ------------------------------------------------------------------
# CLASE 4 - Código definitivo de carga de datos
# Introducción a la Ciencia de Datos - UM
# Dataset: Estación de Transferencia de Residuos (IM), archivo "2023"
#
# Cierre del data profiling: en vez de dejar que readr adivine, se
# declara explícitamente el tipo de cada columna. Así la carga es
# reproducible y no depende de qué haya visto readr en las primeras
# 1000 filas.
# ------------------------------------------------------------------

library(here)
library(readr)

archivo  <- "cantidad_de_residuos_en_la_estacion_de_transferencia_2023.csv"
ruta_csv <- here("clases", "clase4", archivo)

if (!file.exists(ruta_csv)) {
  stop(paste("No se encontró el archivo en:", ruta_csv))
}

# --- Formato de las fechas del archivo: 30/11/23 08:28 --------------
FMT_FECHA <- "%d/%m/%y %H:%M"

tipos <- cols(
  # ---- Identificador -----------------------------------------------
  # Una fila = un pesaje de camión en la balanza. 1222 valores únicos,
  # cero nulos: es LA columna ID.
  pesada                = col_integer(),

  # ---- Fechas ------------------------------------------------------
  # Si quedan como texto, cualquier orden cronológico sale alfabético.
  fecha_dia             = col_datetime(format = FMT_FECHA),
  fecha                 = col_datetime(format = FMT_FECHA),
  viaje_fecha           = col_datetime(format = FMT_FECHA),
  fecha_tara            = col_datetime(format = FMT_FECHA),
  fmod                  = col_datetime(format = FMT_FECHA),  # ¿fecha de modificación? -> lista de NO SÉ

  # ---- Magnitudes (esto SÍ son números) ----------------------------
  peso_neto             = col_double(),   # kg de residuo
  peso_bruto            = col_double(),   # kg camión lleno
  tara                  = col_double(),   # kg camión vacío
  nro_permiso           = col_double(),

  # ---- Códigos: van como texto a propósito -------------------------
  # Son etiquetas, no cantidades. Como double, R te deja calcular
  # mean(tipo_residuo) y eso no significa absolutamente nada.
  matricula_letra       = col_character(),
  tipo_residuo          = col_character(),
  subtipo_residuo       = col_character(),
  balanza               = col_character(),
  medio_transp          = col_character(),
  permiso_id            = col_character(),
  tipo_permiso          = col_character(),
  destino_volcado       = col_character(),
  tipo_pesada           = col_character(),
  sitio                 = col_character(),
  tipo_movimiento       = col_character(),

  # ---- Descripciones -----------------------------------------------
  tipo_residuo_desc     = col_character(),
  subtipo_residuo_desc  = col_character(),
  medio_transp_desc     = col_character(),
  tipo_volcado_desc     = col_character(),  # rompe el patrón: no existe tipo_volcado
  tipo_permiso_desc     = col_character(),
  destino_volcado_desc  = col_character(),
  tipo_pesada_desc      = col_character(),
  sitio_desc            = col_character(),
  tipo_movimiento_desc  = col_character(),
  basura_propia         = col_character(),

  # ---- Columnas 100% vacías: no se cargan ---------------------------
  # 1222 NAs sobre 1222 filas. readr las marca col_logical() porque
  # nunca vio un valor. No aportan nada, solo ensucian el str().
  trayecto              = col_skip(),
  trayecto_desc         = col_skip(),
  tipo_recorrido        = col_skip(),
  tipo_recorrido_desc   = col_skip(),
  nomenclatura_circuito = col_skip(),
  municipio             = col_skip(),
  lugar_salida          = col_skip(),
  lugar_salida_desc     = col_skip(),
  permiso               = col_skip(),
  peso_autorizado       = col_skip()
)

df <- read_csv(ruta_csv, col_types = tipos)

# ------------------------------------------------------------------
# Verificaciones de que la carga salió como se esperaba
# ------------------------------------------------------------------
cat("--- Carga definitiva:", basename(ruta_csv), "---\n")
cat("Dimensiones:", nrow(df), "filas x", ncol(df), "columnas",
    "(se descartaron 10 columnas vacías)\n")

# 1. El ID identifica de verdad
stopifnot(length(unique(df$pesada)) == nrow(df))
cat("OK - 'pesada' identifica unívocamente cada fila\n")

# 2. Sin duplicados exactos
cat("Filas duplicadas:", sum(duplicated(df)), "\n")

# 3. Las fechas quedaron como fechas y el rango real del archivo
cat("Rango de fechas:", format(min(df$fecha)), "->", format(max(df$fecha)), "\n")
cat("Días distintos:", length(unique(as.Date(df$fecha_dia))),
    "  <- OJO: el archivo se llama '2023' pero cubre ~1 mes\n")

# 4. Coherencia de la balanza: peso_neto = peso_bruto - tara
descuadre <- abs(df$peso_bruto - df$tara - df$peso_neto)
cat("Filas donde no cierra el peso:", sum(descuadre > 0), "\n")

# 5. Columnas constantes (varianza cero: parecen variables, no lo son)
constantes <- names(df)[sapply(df, function(x) length(unique(x)) == 1)]
cat("Columnas con un único valor:", paste(constantes, collapse = ", "), "\n")

str(df)
