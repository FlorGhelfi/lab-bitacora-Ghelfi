# Clase 7 — Carga y transformación

**Datos:** ozono minutal de Montevideo, ene–abr 2024. Dos estaciones,
291.926 filas × 5 columnas.

En las clases 4 y 5 bajé un archivo y lo interrogué sin tocarlo. Acá empieza
a modificarse: limpiar, explorar, transformar.

---

## Lo que aprendí

**1. El encoding se arregla al cargar.** Las estaciones venían `ColÃ³n` y
`MaroÃ±as`. La `ó` en UTF-8 ocupa dos bytes; leído como latin-1, cada byte
sale como un carácter distinto. En clase lo arreglamos con un diccionario de
reemplazos, que devuelve `Colon` y `Maronias` — los nombres quedan
mutilados. Probé la otra vía: `locale(encoding = "UTF-8")` en el `read_csv`.
Salen bien y no tocás ni una cadena de texto.

**2. `group_by` + `summarise` es una tabla dinámica.** Cambia la unidad de
observación: pasé de 255.767 filas (una por minuto) a 4 (una por mes).

**3. La columna `n` no está de adorno.**

| mes | O3 medio | n | cobertura |
|---|---|---|---|
| enero | 29,1 | 81.700 | 91% |
| **febrero** | **35,6** | **42.954** | **51%** |
| marzo | 24,0 | 60.466 | 68% |
| abril | 25,7 | 70.647 | 82% |

Febrero: media más alta, mitad de los datos. Agrupé también por estación y
apareció el motivo — Colón estuvo caída casi todo el mes, 1.738 minutos de
41.760.

Lo que no esperaba: Colón pesa tan poco que casi no mueve el promedio. El
problema real es que enero promedia dos estaciones y febrero una. Los cuatro
puntos no miden lo mismo. Igual que comparar ventas totales si abriste o
cerraste locales en el medio.

**4. Hay tres tipos de faltante.**

| Tipo | Qué es | Cómo se detecta |
|---|---|---|
| Explícito | La fila existe, `o3` es `NA` | `colSums(is.na())` |
| En rachas | NA seguidos, sensor caído | `rle()` |
| **Implícito** | **La fila no existe** | Ninguna función de NA lo ve |

36.159 NA explícitos. Pero al agregar por hora quedaron 4.312 horas cuando
deberían ser 5.808: faltan 1.496, el 26%, y no aparecen en ningún conteo
porque no hay fila que contar.

Por eso guardamos dos objetos: `ozono_sinna` para calcular y `ozono_limpio`
para investigar. Borrar los NA antes de mirarlos borra la evidencia de cómo
se midió.

**5. `geom_line` dibuja líneas donde no hay nada.** Con `facet_wrap`
aparecieron dos diagonales rectas: Colón en febrero, Maroñas en marzo. No son
datos, son el agujero — `geom_line` une el último punto con el siguiente
aunque falten 700 horas. Se arregla con `complete()`, que inserta filas con
`NA` y corta la línea.

No es solo estético: la media móvil de 8 horas necesita la grilla completa,
si no agarra ocho *filas* que pueden abarcar tres días.

**6. Qué estadístico representa el fenómeno.** A 1.440 mediciones les
agregamos 10 picos falsos de 500, menos del 1%:

| | sin picos | con picos | cambio |
|---|---|---|---|
| media | 31,76 | 34,99 | +10,2% |
| p95 | 62,02 | 63,30 | +2,1% |

El máximo se va a 500: deja de describir el ozono y describe el error del
sensor. Por eso la OMS usa el máximo diario de la media móvil de 8 h, no el
máximo.

**7. Las fechas son números.** `POSIXct` guarda los segundos desde el
1/1/1970. Para agregar por hora hay que fabricar una clave que se repita:
`floor_date(fecha, "hour")`.

**8. `pivot_longer` para graficar varias series.** `ggplot` mapea una sola
columna al color, así que hay que pasar `media`, `p95` y `maximo` de tres
columnas a dos: una con el nombre y otra con el valor.

---

## Lo que encontré yo

**La caída de Colón en febrero** — agrupando por mes *y* estación. En clase
nos quedamos en el promedio mensual y ahí no se ve.

**Las 1.496 horas que no existen** — comparando las 4.312 presentes contra
las 5.808 esperadas. Ese número no lo devuelve ninguna función, hay que
calcularlo.

Las dos son lo mismo: el dato que falta no avisa. Hay que buscarlo comparando
contra lo que uno espera.

