# Clase 9 — Visualización básica en R (ggplot2)

## Geometrías: dibujá lo que querés mostrar

En ggplot, la geometría es básicamente cómo le decís al gráfico que pinte tus datos. Tenés `geom_line()` que conecta los puntos, `geom_point()` que muestra solo los puntos. Cada una cuenta una historia distinta con los mismos números.

Con solo línea ves la tendencia pero perdés de vista dónde está cada valor exactamente. Con solo puntos ves los datos pero te pierdes cómo fluye el tiempo entre uno y otro. Juntos es lo que funciona: tendencia + precisión. Eso es lo que casi siempre querés.

## Un gráfico decente tiene esto

El título no puede ser "Concentración de Ozono". Tiene que contar qué es, cuándo es, dónde. "Ozono troposférico: media mensual, enero a abril de 2024" es mucho mejor porque alguien que lo ve entiende al instante qué está pasando.

Los ejes necesitan etiquetas con unidades. No es solo "Ozono" sino "Ozono (µg/m³)". Parece un detalle boludo pero cuando alguien lee tu gráfico seis meses después (o la profe lo califica) necesita saber en qué unidades estás hablando.

La escala importa más de lo que parece. Si el eje Y va de 0 a 40 ves la realidad: los cambios son moderados. Si arrancara en 20 parecería que febrero se dispara como un cohete cuando en realidad subió menos del 25%. Es el viejo truco de manipular gráficos sin mentir técnicamente.

El grid —esas líneas de fondo— ayuda a leer números pero si dejas todas se ve saturado. Sacamos las menores, dejamos las que importan. Es un detalle visual pero respira.

Y la fuente, siempre. "Fuente: valores leídos del gráfico original" o donde sea que vengan los datos. Es honesto y profesional.

## De lo básico a lo pulido

El script muestra exactamente eso. El mismo gráfico en tres versiones. La primera funciona pero es genérica. La tercera se ve como si alguien realmente pensó qué estaba mostrando.

Qué cambió? Líneas que parecen nada pero van directo. `scale_x_continuous()` para meter los meses en letras en vez de números. `scale_y_continuous()` para definir que el eje va de 0 a 40 y marca cada 5. Una línea que saca el grid menor. Y en `labs()` toda la información que necesita alguien para entender de qué se trata.

## Guardá lo que hiciste

`ggsave()` guarda tu gráfico como PNG o PDF. El script usa una función `guardar()` que envuelve todo para no tener que repetir los mismos parámetros. Resolución 300 dpi porque si después lo imprimís o lo presentás necesita verse bien.