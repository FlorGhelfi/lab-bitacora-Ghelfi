# Bitácora — Recolección de datos por el tacto

**Fecha:** 18 de agosto de 2026

---

## La actividad

Tantear objetos con los ojos vendados, registrar lo que percibe la mano como variables binarias y asignarle a cada objeto una etiqueta.

Es un ejercicio de recolección de datos disfrazado de juego: al taparse los ojos uno queda reducido a un único sensor, y eso obliga a decidir explícitamente **qué se mide y cómo**, que es justamente el problema que en un proyecto real queda escondido debajo de un dataset ya armado.

## Los datos

**7 objetos** (observaciones) × **22 características** (variables binarias) + **1 etiqueta** (clase).

| | |
|---|---|
| Objetos | Cubo Rubik, lapicera, peluche, círculo de plástico, tuerca, cable con parte metálica, block de notas |
| Grupos de variables | Geometría (10), Textura y material (6), Propiedades físicas (6) |
| Etiquetas | Juguete (2), Escritorio (2), Ferretería (1), A – no identificado (2) |

Cada variable vale `1` si el objeto presenta la característica y `0` si no. El criterio para decidir entre uno y otro está en `diccionario_variables.csv`.

---

## Lo que aprendí

### 1. Un dato no es lo que se percibe, sino lo que se registra

"Es rugoso" no es un dato hasta que existe una variable con una definición operativa que diga qué cuenta como rugoso. Sin esa definición, dos personas describen el mismo objeto distinto y el dataset deja de ser reproducible.

### 2. Las variables tienen que ser las mismas para todos los casos

Aunque el valor sea 0. La tentación es describir cada objeto con las variables que le quedan cómodas — "el peluche es suave", "la tuerca tiene rosca" — pero así después no se puede comparar nada. La estructura común es lo que convierte observaciones sueltas en un dataset.

### 3. La elección de las variables sesga el resultado

El total por fila **no** mide la complejidad del objeto: mide cuántas de *mis* variables tiene. Como elegí 10 columnas de geometría y solo 6 de material, los objetos angulares dan totales más altos. El sesgo no está en los datos, está en el diseño del instrumento.

### 4. Hay variables que no sirven y variables duplicadas

Una columna constante no separa nada y se descarta. Y en este dataset aparecieron **cinco pares de columnas idénticas**:

```
vertices        == aristas
agujero         == pesado_p_tamano
superficie_lisa == plastico
afelpado        == deformable
metalico        == frio_al_tacto
```

Cada par aporta una sola vez la misma información. Algunos son redundancia real (todo lo metálico se siente frío); otros son un artefacto de tener solo 7 observaciones — con más objetos, `agujero` y `pesado_p_tamano` se separarían.

### 5. Las *features* y la *etiqueta* viven en planos distintos

Este fue el hallazgo central. Las features salen del sensor; la etiqueta sale del conocimiento del observador. El caso testigo:

> **Cubo Rubik y peluche tienen similitud de Jaccard = 0.00** — no comparten ni una característica — **y sin embargo llevan la misma etiqueta: "Juguete".**

Llevado al extremo, la similitud física promedio *dentro* de cada clase (**0.150**) resultó **más baja** que entre clases distintas (**0.252**). Es decir: los objetos que comparten etiqueta se parecen *menos* entre sí que los que no.

El dendrograma lo confirma — los grupos que surgen de agrupar por características no coinciden con las clases asignadas. Con estas variables, ningún modelo podría aprender la etiqueta: la información que la determina simplemente no está en las columnas. Esa brecha entre lo que el sensor mide y lo que la etiqueta significa es el problema que intenta resolver el aprendizaje supervisado.

### 6. "No identificado" es una clase legítima

Dos objetos no los pude reconocer. La tentación es forzarlos a la clase más cercana, pero eso mete ruido. Una clase explícita de *no identificados* preserva la información de que ahí hay incertidumbre, y marca exactamente qué casos hay que revisar después con más contexto o más datos.

### 7. La confiabilidad depende del diccionario, no del anotador

Si dos compañeros etiquetan el mismo objeto distinto, el problema no está en ellos: está en que la definición de la variable era ambigua. Por eso el diccionario de variables es parte del dataset, no documentación opcional.

---

## Conceptos que quedaron claros

`observación` · `variable` · `variable binaria / dummy` · `definición operativa` · `diccionario de datos` · `features vs. target` · `clase / etiqueta` · `balance de clases` · `redundancia y colinealidad` · `índice de Jaccard` · `agrupamiento jerárquico` · `concordancia entre anotadores`
