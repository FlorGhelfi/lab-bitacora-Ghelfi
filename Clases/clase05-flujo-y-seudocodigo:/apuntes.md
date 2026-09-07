# Clase 5 — Flujo de datos, seudocódigo y carga 2

## 1. Cargar los paquetes

```r
library(here)
library(readr)
```

`here` resuelve rutas desde la raíz del proyecto. `readr` aporta `read_csv()`, la función que lee CSVs.

Ojo con el orden: `library(here)` calcula la raíz **en el momento en que se ejecuta**, mirando dónde está parado R. Si R está parado en el lugar equivocado, `here` se queda con la raíz equivocada para toda la sesión.

## 2. Armar la ruta

```r
archivo  <- "cantidad_de_residuos_en_la_estacion_de_transferencia_2023.csv"
ruta_csv <- here("clases", "clase4", archivo)
```

Dos cajas. `archivo` guarda el nombre; `ruta_csv` guarda la dirección completa que arma `here()` pegando la raíz del repo adelante.

Separarlo en dos variables es importante

## 3. Cargar

```r
df <- read_csv(ruta_csv)
```

Va a esa dirección, abre el CSV, lo convierte en tabla y lo guarda en `df`. **Esta es la única línea que trae datos**; todo lo demás es preparación o inspección.

`read_csv` además *adivina* el tipo de cada columna leyendo las primeras 1000 filas.

## 4. Dimensiones y estructura

```r
cat("--- Archivo cargado:", basename(ruta_csv), "---\n")
cat("Dimensiones (filas, columnas):", dim(df), "\n")
str(df)
```

`cat()` imprime texto en la consola. `basename()` recorta la ruta y deja solo el nombre del archivo. El `\n` es un salto de línea.

`dim(df)` devuelve `1222 41` — filas y columnas.

`str()` es la radiografía: lista cada columna con su tipo y sus primeros valores. Es la forma más rápida de ver si algo entró mal.

## 5. Primeras filas

```r
head(df)
```

Las primeras 6 filas. Sirve para confirmar que los datos son lo que esperabas y que las columnas están alineadas — si el delimitador estuviera mal, acá se ve enseguida.

## 6. Buscar el identificador

```r
sapply(df, function(x) length(unique(x)))
```

El paso más importante del script:

- `unique(x)` — de una columna, dejá solo los valores distintos
- `length(...)` — contá cuántos quedaron
- `sapply(df, function(x) ...)` — hacé eso **para cada columna** de `df`

`sapply` significa *"simplify apply"*: aplica una función a cada elemento de una lista (y un data frame es una lista de columnas) y te devuelve el resultado ordenadito.

El criterio: **la columna cuyo número de valores únicos coincide con la cantidad de filas es el identificador.** Acá `pesada` da 1222, igual que `nrow(df)`. `matricula_letra` da 12 — son 12 camiones haciendo 1222 viajes.

Y eso te define la **unidad de observación**: cada fila es una descarga de camión, no un camión ni un día.

## 7. Datos faltantes

```r
colSums(is.na(df))
colSums(df == "", na.rm = TRUE)
```

**Primera línea:** `is.na(df)` convierte toda la tabla en TRUE/FALSE — TRUE donde falta el dato. `colSums()` suma por columna, y como TRUE vale 1, te queda el conteo de faltantes.

Es el mismo mecanismo de `temperaturas > 20` del ejercicio de seudocódigo: una comparación aplicada a todo de una, que devuelve TRUE/FALSE. Eso es **vectorización**.

**Segunda línea:** los *falsos nulos*. Celdas que tienen un texto vacío `""` en vez de un `NA` de verdad. Para R son datos válidos, así que `is.na()` no los ve, pero en la práctica son faltantes igual. El `na.rm = TRUE` le dice que ignore los NA reales mientras hace esa comparación.

En este archivo dan 0: no hay falsos nulos.

## 8. Duplicados

```r
sum(duplicated(df))
```

`duplicated(df)` recorre las filas y pregunta *"¿esta fila exacta ya apareció antes?"*. Devuelve TRUE/FALSE por fila; `sum()` cuenta los TRUE.

Detalle: la primera aparición cuenta como FALSE. Solo marca las repeticiones. Da **0**.

---

## Lo que hay que retener

El script recorre las dos primeras etapas del flujo que viste en el teórico: **Ingesta** (pasos 1 a 3) y **Perfilado** (4 a 8). No modifica un solo dato — solo pregunta.

Y el orden de las preguntas no es casual: **¿de qué tamaño es? → ¿qué estructura tiene? → ¿qué identifica cada fila? → ¿qué falta? → ¿qué se repite?** Sirve para cualquier tabla que te caiga en las manos, en R, en Python o en SQL.
