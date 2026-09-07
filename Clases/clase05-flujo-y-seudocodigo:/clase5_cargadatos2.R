##El script recorre las dos primeras etapas del flujo que viste en el teórico: Ingesta (pasos 1 a 3) y Perfilado (4 a 8). No modifica un solo dato — solo pregunta.
##Y el orden de las preguntas no es casual: ¿de qué tamaño es? → ¿qué estructura tiene? → ¿qué identifica cada fila? → ¿qué falta? → ¿qué se repite? Sirve para cualquier tabla que te caiga en las manos, en R, en Python o en SQL.

library(here)
here()
getwd()
here()
library(readr)

# 1. Definir la ruta del archivo con here
archivo <- "cantidad_de_residuos_en_la_estacion_de_transferencia_2023.csv"
ruta_csv <- here("clases", "clase4", archivo)

# 2. Cargar el archivo CSV --> Va a esa dirección, abre el CSV, lo convierte en tabla y lo guarda en df. Esta es la única línea que trae datos; todo lo demás es preparación o inspección. read_csv además adivina el tipo de cada columna leyendo las primeras 1000 filas.
df <- read_csv(ruta_csv)

# 3. Profiling inicial: Dimensiones y estructura
cat("--- Archivo cargado:", basename(ruta_csv), "---\n")
cat("Dimensiones (filas, columnas):", dim(df), "\n")
str(df)
#cat() imprime texto en la consola. basename() recorta la ruta y deja solo el nombre del archivo. El \n es un salto de línea.
#dim(df) devuelve 1222 41 — filas y columnas.
#str() es la radiografía: lista cada columna con su tipo y sus primeros valores. Es la forma más rápida de ver si algo entró mal.


# 4. Primeras filas
head(df)
#Las primeras 6 filas. Sirve para confirmar que los datos son lo que esperabas y que las columnas están alineadas — si el delimitador estuviera mal, acá se ve enseguida.


# 5. Detección de Columna ID (Comprobar valores únicos por columna)
# Si el resultado es igual a nrow(df), esa columna es un ID único
cat("\nValores únicos por columna (Buscar candidatos a ID):\n")
sapply(df, function(x) length(unique(x)))
#El criterio: la columna cuyo número de valores únicos coincide con la cantidad de filas es el identificador. Acá pesada da 1222, igual que nrow(df). matricula_letra da 12 — son 12 camiones haciendo 1222 viajes. Y eso te define la unidad de observación: cada fila es una descarga de camión, no un camión ni un día.


# 6. Diagnóstico de datos faltantes y falsos nulos
cat("\nValores nulos (NA) por columna:\n")
colSums(is.na(df))

cat("\nFalsos nulos (Cadenas vacías '') por columna:\n")
colSums(df == "", na.rm = TRUE)

# 7. Diagnóstico de filas duplicadas
cat("\nTotal de filas exactamente duplicadas:\n")
sum(duplicated(df))
