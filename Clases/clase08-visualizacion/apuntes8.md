# Clase 8 — Visualización y Python

Dos cosas: el mismo análisis del ozono traducido a Python, y un PDF que
desarma un gráfico parte por parte.

Primera vez que uso Python.

## El entorno

Python no se corre en RStudio. Se usa VS Code, y hay que configurar dos
cosas antes de que ande nada.

**Restricted Mode.** VS Code abre las carpetas en modo lectura hasta que le
decís que confiás. Con eso activo no ejecuta una línea.

**El intérprete.** Puede haber varias versiones de Python instaladas. Hay
que elegir cuál, y conviene la de Anaconda porque ya trae pandas, numpy y
matplotlib. Cmd+Shift+P → "Python: Select Interpreter".

El script viene con marcas `#%%` que VS Code lee como celdas. Shift+Enter
corre una línea o un bloque en el panel *Interactive*, igual que el
Cmd+Enter de RStudio.

## R y pandas dicen lo mismo distinto

| R | Python |
|---|---|
| `group_by` + `summarise` | `.groupby().agg()` |
| `mutate` | `.assign()` |
| `filter(!is.na(x))` | `.dropna(subset=["x"])` |
| `distinct()` | `.drop_duplicates()` |
| `floor_date(f, "hour")` | `pd.Grouper(key="fecha", freq="h")` |
| `lubridate::year()` | `.dt.year` |
| `POSIXct` | `datetime64[ns]` |
| `complete()` | `.reindex()` sobre la grilla |
| `stats::filter` (media móvil) | `.rolling(8).mean()` |

El análisis no cambió. Cambió cómo se escribe.

Detalle: `read_csv` de R detecta las fechas solo. pandas necesita que le
digas `parse_dates=["fecha"]`, si no te las deja como texto.


## Funciones

Lo nuevo del código. Un bloque con nombre que recibe cosas y devuelve algo:

```python
def grafico_ozono(datos, color_puntos="red", color_linea="blue", ylim=(0, 40)):
```

`datos` es obligatorio. Los otros tres tienen valor por defecto, así que si
no digo nada usa ese.

Sin la función habría que copiar y pegar trece líneas cada vez que quiero
cambiar un color. Con la función, cambio un argumento:

```python
grafico_ozono(ozono_mes, color_puntos="green")
```

Definir la función no la ejecuta. Solo la deja guardada.

## Las partes de un gráfico

Un gráfico no es una cosa. Son diez decisiones apiladas, y casi todas se
toman por defecto sin darse cuenta.

| Parte | Qué controla | Dónde se toca |
|---|---|---|
| Figura | Lienzo y tamaño | `figsize=` |
| Ejes | Área de datos y escalas | `ax` |
| Título | Qué, de quién, cuándo | `title=` |
| Etiquetas de eje | Variable y unidad | `xlabel=`, `ylabel=` |
| Marcas | Posición a valor | `set_xticks()`, `set_ylim()` |
| Geometría | Cómo se dibujan | `plot()`, `scatter()` |
| Atributos | Color, grosor, orden | `color=`, `s=`, `zorder=` |
| Grilla | Lectura de valores | `grid()` |
| Bordes | Marco del área | `spines[...]` |
| Guardado | Archivo de salida | `fig.savefig()` |

`fig` es el lienzo, `ax` es el sistema de ejes. Una figura puede tener
varios ejes, por eso `plt.subplots()` devuelve las dos cosas.


## Lo que aprendí

**Mi gráfico de la clase 7 estaba mal y el PDF lo dice.** "Valores" en el
eje y no informa nada: falta la variable y falta la unidad. Y el eje x
mostraba marcas en 1,5 / 2,5 / 3,5 — meses que no existen — porque `mes` es
numérico y matplotlib lo trata como continuo. Se arregla fijando las marcas
a mano.

**El eje y que no arranca en cero exagera la variación.** Es admisible, pero
es una decisión. Y es la forma más común de mentir con un gráfico en un
informe: recortás el eje y una diferencia chica parece un derrumbe.

**Un color no es información hasta que codifica una variable.** El azul de
la línea y el rojo de los puntos son legibilidad, nada más. Pasan a
informar recién cuando los asigno a algo, por ejemplo un color por estación.

**La línea y los puntos dicen cosas distintas.** La línea afirma que hay
continuidad entre meses. Los puntos marcan dónde hay medición de verdad y
frenan la lectura de valores intermedios que nadie observó. Juntos: se ve la
tendencia sin perder que los datos son discretos.

**`fig.savefig()` va antes de `plt.show()`.** Con algunos backends, mostrar
la figura la vacía y el archivo sale en blanco.

**En Python los espacios del principio no son estética.** Definen qué está
adentro de qué. Me comí un `IndentationError` por poner dos espacios de más.
En R eso lo hacen las llaves.


## Detalles

- El script vuelve a cargar con `latin1`, así que reaparecen `ColÃ³n` y
  `MaroÃ±as`. Cambié a `utf-8` y listo, igual que en la clase 7.
- Comenté la carga del autoscope: nunca conseguí ese CSV y no se usa en
  ninguna otra parte.
- Las rutas apuntaban al repo de la profe. Una variable `CARPETA` arriba y
  todo lo demás la reusa.

