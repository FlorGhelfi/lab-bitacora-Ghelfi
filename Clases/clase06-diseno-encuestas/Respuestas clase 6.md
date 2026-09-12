# Clase 6 — Para la bitácora


## 1. ¿Está conforme con lo que gasta en comida y en transporte?

**El problema.** Son dos preguntas en una. Si estoy conforme con
lo que gasto en comida pero no con el transporte, no tengo cómo decirlo.
Si alguien marca "sí", no sé a cuál de las dos le dijo que sí.

La "y" en el medio es el problema.

**Reescrita.** Se parte en dos:

> P. ¿Qué tan conforme está con lo que gasta en **comida**?
> 1 Nada conforme · 2 · 3 · 4 · 5 Muy conforme

> P. ¿Qué tan conforme está con lo que gasta en **transporte**?
> 1 Nada conforme · 2 · 3 · 4 · 5 Muy conforme

**Columnas.** Dos, `conforme_comida` y `conforme_transporte`. Las dos
ordinales. Son números, pero la distancia entre 2 y 3 no es la misma que
entre 4 y 5, así que promediarlas es una decisión que hay que avisar.


## 2. ¿No le parece que gasta demasiado en salidas?

**El problema.** Tres cosas mal en esta frase.

Empieza con una negación, y contestar "no" a una pregunta negativa no se
entiende. ¿No me parece que gasto demasiado, o no estoy de acuerdo con la
pregunta?

"¿No le parece que...?" ya trae la respuesta adentro. El que pregunta ya
opinó, y la gente tiende a acompañar.

Y "demasiado" es un juicio, no una cantidad. Cada uno tiene su vara.

**Reescrita.** Si quiero el dato duro:

> P. ¿Cuánto gastó en salidas en los últimos 30 días? $ ______

Si lo que me interesa es la percepción, que es otra cosa:

> P. ¿Cómo describiría lo que gasta en salidas?
> 1 Muy poco · 2 · 3 · 4 · 5 Mucho

**Columnas.** Una. La primera versión da `gasto_salidas`, cuantitativa —
conserva más información y me deja armar tramos después. La segunda da
`percepcion_salidas`, ordinal.

Son indicadores de dimensiones distintas del mismo concepto. Si el
cuestionario da para las dos, van las dos.

## 3. ¿Cuánto gastó últimamente en ropa?

**El problema.** "Últimamente" no es un tiempo especificamente. Uno piensa en la semana,
otro en el mes, otro en lo que va del año. Cada respuesta mide algo
distinto y después las sumo como si fueran comparables.

La pregunta apunta a lo correcto. Lo que falla es que no mide lo mismo dos
veces seguidas.

**Reescrita.**

> P. ¿Cuánto gastó en ropa en los últimos 30 días? $ ______

**Columnas.** Una, `gasto_ropa`, cuantitativa.

Y el período elegido hay que sostenerlo en todo el cuestionario. No sirve
preguntar comida a 30 días y ropa "en un mes típico".

## 4. Gasto en transporte: ☐ $0 a $1.000 ☐ $1.000 a $3.000 ☐ $3.000 a $6.000

**El problema.** Los tramos se pisan y aparte, no cubren todo.

Si gasté $1.000 puedo marcar las dos primeras. Si gasté $3.000,
las dos últimas. Y si gasté $7.000 no tengo cómo decirlo.

Toda respuesta posible tiene que entrar en una casilla. En una sola.

**Reescrita.**

> P. ¿Cuánto gastó en transporte en los últimos 30 días?
> ☐ Nada ☐ Hasta $1.000 ☐ $1.001 a $3.000 ☐ $3.001 a $6.000 ☐ Más de $6.000

Agregué "Nada" al principio, corté los bordes para que no se superpongan y
abrí la última categoría.

**Columnas.** Una, `gasto_transporte`, ordinal.

Preguntar por tramos en vez de pedir el monto sube la cantidad de respuestas.
El costo es que pierdo el promedio y no puedo recortar
otros tramos después. Se decide antes de salir a campo, porque no se
deshace.

## 5. ¿Cómo paga sus gastos? ☐ Efectivo ☐ Tarjeta ☐ Ambos ☐ Transferencia

**El problema.** El "Ambos" delata que la pregunta admite más de una
respuesta y yo la estoy forzando a una sola.

Además está mal armado: "Ambos" cubre efectivo y tarjeta, pero no
contempla a quien usa tarjeta y transferencia. Con tres medios de pago
necesitaría siete combinaciones.

**Reescrita, versión A** — selección múltiple:

> P. ¿Con cuáles de estos medios pagó sus gastos en los últimos 30 días?
> (marque todas las que correspondan)
> ☐ Efectivo ☐ Tarjeta ☐ Transferencia

**Columnas.** Tres: `pago_efectivo`, `pago_tarjeta`, `pago_transferencia`.
Binarias, 0 o 1.

Una opción, una columna. Guardar la respuesta como un solo texto
—`"Efectivo; Transferencia"`— esta mal: después no se puede
filtrar ni contar sin volver a procesar todo.

**Reescrita, versión B** — si necesito una sola columna:

> P. ¿Cuál es su **principal** medio de pago?
> ☐ Efectivo ☐ Tarjeta ☐ Transferencia

**Columnas.** Una, `medio_pago_principal`, nominal. La palabra "principal"
es la que vuelve la pregunta excluyente.

## 6. (Primera pregunta) ¿Cuál es el ingreso mensual exacto de su hogar?

**El problema.** Esta es la peor de las seis.

Va **primera**. Arrancar un cuestionario preguntando cuánta plata entra en
la casa es la forma más rápida de que la persona lo cierre. Las preguntas
sensibles van al final, cuando ya contestó el resto: si abandona ahí, por lo
menos me quedo con lo anterior.

Pide el monto **exacto**. Poca gente lo sabe de memoria, y la que lo sabe no
siempre lo quiere escribir.

Dice "**su hogar**" en un cuestionario a estudiantes. Cambia la unidad de
análisis sin avisar: las demás preguntas son sobre la persona y esta es
sobre el hogar. Y un estudiante puede no saber cuánto entra en la casa.

**Reescrita.** Al final del cuestionario, por tramos, y aclarando por quién
se responde:

> P. Pensando en **todas las personas que viven con usted**, ¿en qué rango se
> ubica el ingreso mensual del hogar?
> ☐ Menos de $40.000 ☐ $40.001 a $70.000 ☐ $70.001 a $120.000
> ☐ Más de $120.000 ☐ Prefiere no contestar

**Columnas.** Una, `ingreso_hogar`, ordinal.

El "Prefiere no contestar" es una decisión de diseño, no un descuido. Si lo
ofrezco, tengo que definir en el libro de códigos cómo se codifica y cómo lo
distingo de la celda que quedó vacía porque la persona se saltó la pregunta.
En la tabla las dos se ven igual.

## Lo que se repite en las seis

Ninguna se arregla escribiendo "más lindo "mejor". Se arreglan preguntando **qué
columna genera esto**.

La 1 no sabía qué columna producía. La 4 no sabía en qué celda cae un valor
del borde. La 5 pedía una columna cuando necesitaba tres. La 6 cambiaba de
unidad de análisis a mitad del cuestionario.

Entonces, es muy importante diseñar la tabla antes que el formulario.