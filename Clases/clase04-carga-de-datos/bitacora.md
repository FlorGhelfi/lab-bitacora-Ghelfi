# Bitácora — Carga de datos y data profiling

**Fecha:** 1 de septiembre de 2026

---

## La clase

Abrir un CSV real y, antes de analizarlo, interrogarlo.

Es la continuación natural de la actividad de los objetos: si aquella mostró que el dataset es la **salida** de un proceso y no la realidad, esta enseña a auditar esa salida. La diferencia es que acá la caja negra no la armé yo — el archivo lo generó el sistema de la Intendencia de Montevideo y me llegó hecho. Todo lo que puedo hacer es interrogarlo.

## Los datos

`cantidad_de_residuos_en_la_estacion_de_transferencia_2023.csv` — Catálogo de Datos Abiertos UY, publicado por la Intendencia de Montevideo. Registro de pesajes de camiones en la Estación de Transferencia (ETRA).

| | |
|---|---|
| Filas | 1.222 |
| Columnas | 41 |
| Unidad de observación | Un pesaje de camión en la balanza |
| Identificador | `pesada` |
| Delimitador | Coma |
| Peso | 364 KB en disco, ~1,6 MB en memoria |

---

## Lo que aprendí

### 1. La ruta absoluta rompe la reproducibilidad

`setwd("C:/Users/jodavyt/...")` funciona en una sola computadora del mundo. Cualquier otra persona que abra el proyecto recibe un error.

`here()` resuelve el problema al revés: no guarda la ruta, la **calcula** en el momento de ejecutar, buscando hacia arriba el `.git` del repo. Lo que queda escrito en el código es solo la parte relativa — `here("clases", "clase4", archivo)` — y esa parte es igual en todas las máquinas.

El detalle que me ordenó la cabeza: `here()` **devuelve** una ruta absoluta. Lo relativo no es el resultado, es lo que uno escribe.

### 2. El nombre del archivo puede mentir

El archivo se llama `..._2023.csv`. Las fechas van del **30/11/2023 al 31/12/2023**: 30 días, y 1.210 de las 1.222 filas son de diciembre.

Si hubiera confiado en el nombre y calculado "residuos recibidos en 2023", el resultado habría sido **7.735 toneladas** — un mes de operación presentado como un año entero.

Ninguna función lo avisa. La única forma de detectarlo es preguntarle al dato por su propio rango antes de usarlo.

### 3. El identificador se prueba, no se supone

La slide sugería `matricula_letra`. Tiene **12 valores únicos** para 1.222 filas: son 12 camiones haciendo 1.222 viajes.

El identificador real es `pesada`: 1.222 valores únicos, cero nulos. Y eso además define la unidad de observación — cada fila es una **descarga**, no un camión, no un día, no un tipo de residuo. De ahí depende todo lo que se pueda calcular después: para toneladas por día hay que agrupar, para viajes por camión también.

El criterio operativo es simple y sirve siempre: `n_únicos == n_filas` **y** `n_nulos == 0`.

### 4. De 41 columnas, 26 dicen algo

**10 columnas están 100% vacías** — 1.222 NAs sobre 1.222 filas:

```
trayecto · trayecto_desc · tipo_recorrido · tipo_recorrido_desc
nomenclatura_circuito · municipio · lugar_salida · lugar_salida_desc
permiso · peso_autorizado
```

Y otras **5 tienen un único valor** en todo el dataset: `sitio_desc` siempre "ETRA", `tipo_movimiento_desc` siempre "DESCARGA", `basura_propia` siempre "NO", `tipo_pesada_desc` siempre "AUTOMATICA", `destino_volcado_desc` siempre lo mismo.

Las vacías son fáciles de ver. Las constantes son peores: **parecen variables**. Tienen nombre, tienen tipo, ocupan una columna — pero varianza cero es información cero.

Es el sistema de la Intendencia arrastrando campos de otros flujos que en la estación de transferencia nunca se llenan. Exactamente la caja negra de la actividad anterior, pero ahora ajena y en el pasado.

### 5. Un NA puede significar algo

Las cuatro columnas de permisos (`nro_permiso`, `permiso_id`, `tipo_permiso`, `tipo_permiso_desc`) tienen **828 NAs** — el 68% de las filas.

No es un dato perdido: es que esos 828 viajes fueron **sin permiso**, y el campo quedó vacío porque no correspondía. Rellenar eso con un cero o descartar esas filas destruiría información real.

Distinguir "falta el dato" de "no corresponde el dato" es una decisión de análisis, y hay que tomarla mirando el dominio, no la tabla.

### 6. El tipo que adivina el lector no es inocente

`read_csv()` mira las primeras filas y decide. Se equivocó en dos direcciones opuestas:

**Fechas leídas como texto.** `sort()` las ordena alfabéticamente, así que `01/12/23` queda antes que `30/11/23`. El orden cronológico sale mal y no salta ningún error.

**Códigos leídos como números.** `mean(df$tipo_residuo)` devuelve **1,09** sin protestar. Es el promedio de unos códigos de categoría: no significa nada. Declarándolos como texto, R devuelve `NA` y avisa — que es el comportamiento correcto.

Un detalle útil: en el `spec()` de readr, `col_logical()` en una columna que no es booleana es la señal de que está **vacía**. readr le pone lógico porque nunca vio un valor.

### 7. El código definitivo de carga

La exploración termina cuando se puede escribir una sola línea de carga que ya no adivine nada. En `carga_definitiva.R` quedaron declaradas las 41 columnas: fechas con su formato (`%d/%m/%y %H:%M`), pesos como numéricos, códigos como texto, y las 10 vacías con `col_skip()`. Resultado: 31 columnas, todas con tipo y significado conocido.

El criterio para saber si está terminado: borrar la sesión, correr solo ese script y llegar al mismo objeto. Si hace falta recordar algo que se hizo a mano en la consola, no está terminado.

### 8. Arreglar los tipos rompe código que andaba de casualidad

Después de declarar los tipos, la línea de falsos nulos de la clase empezó a fallar:

```
Error in as.POSIXlt.character(x, tz, ...) :
  character string is not in a standard unambiguous format
```

Compara cada columna contra `""`. Mientras todo era texto, funcionaba. Con las fechas ya convertidas, R intenta transformar `""` en fecha para poder comparar y se planta.

El código viejo no estaba bien: estaba **funcionando por accidente**, porque todos los tipos estaban mal de la misma manera. Se arregla preguntando primero si la columna es texto:

```r
sapply(df, function(x) if (is.character(x)) sum(x == "" | x == "N/A", na.rm = TRUE) else 0)
```

### 9. También hay que verificar lo que sí está

Además de buscar lo que falta, conviene chequear que lo presente sea coherente. La báscula pesa el camión lleno (`peso_bruto`), el camión vacío (`tara`), y la diferencia es la basura (`peso_neto`).

`peso_bruto − tara − peso_neto = 0` en **las 1.222 filas**, sin una sola excepción. Cero duplicados exactos, también.

Este dataset es confiable en su medición. Sus problemas son de **cobertura** — un mes disfrazado de año — y de **completitud** — 15 columnas que no dicen nada. No de precisión.

---

## El orden del profiling

El recorrido que quedó, y que sirve para cualquier tabla nueva:

**ruta → carga → estructura → identidad → completitud → duplicados → tipos → coherencia**

Recién después de eso empieza el análisis.

---

## Conceptos que quedaron claros

`ruta relativa vs. absoluta` · `raíz de proyecto` · `data profiling` · `unidad de observación` · `clave primaria` · `cardinalidad` · `valores faltantes vs. falsos nulos` · `NA estructural` · `columna constante` · `duplicados` · `inferencia de tipos` · `parseo de fechas` · `código definitivo de carga` · `chequeo de coherencia`
