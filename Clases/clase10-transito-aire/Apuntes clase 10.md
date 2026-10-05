# ¿Se ve el tránsito en el aire? Clase 10

## De qué va la pregunta

En Montevideo, junio de 2024. Tenemos tres cosas medidas:
- Contadores de autos en la calle (55 puntos de conteo en Tres Cruces, por ejemplo)
- NO2 en el aire (en tres estaciones meteorológicas)
- PM2.5 en el aire (también en las estaciones)

La pregunta simple: **cuando hay más tránsito, ¿hay más contaminación?** Y más difícil: **¿con qué demora?** --> es un ejemplo múy útil para nuestro proyecto, ya que también medimos "con qué demora"

## Lo que vimos paso a paso

### PASO 1-2: Dónde medimos y dónde elegimos mirar

El mapa mostró algo obvio pero importante: los contadores de tránsito están repartidos por todos lados (muchos en el centro). Las estaciones de aire son pocas (tres). No todas las estaciones tienen suficientes contadores cercanos.

Tres Cruces: 55 puntos de conteo a menos de 1,5 km. Una estación perfecta.
Curva de Maroñas: solo 4 puntos. Mal.

**Lección:** Si quiero medir algo, necesito buenos datos. Sin eso, no ves nada aunque esté ahí.--> "garbage in, garbage out"

### PASO 3-4: El ritmo es obvio, pero con diferentes demoras

Una semana de datos muestra lo que esperaesperaba:
- **Tránsito:** Sube de día (pico ~8am), baja de noche. El fin de semana es tranquilo.
- **NO2:** Sube de día similar, pero pico ~11am (3 horas después del tránsito).
- **PM2.5:** Distinto. Pico entrada la noche (~21h). Algo raro pasa.

Cuando miramos el "día típico" (promedio de todos los días), se ve claro:
- El tránsito y el NO2 tienen ritmos parecidos, pero desfasados.
- El PM2.5 tiene el pico mucho más tarde, casi de noche.

**Primer sospecha:** El NO2 responde rápido. El PM2.5 tarda más.

### PASO 5-6: Separar el ciclo diario del resto

Correlación cruda (hora a hora):
- NO2 vs tránsito: r = 0.59. Moderada.
- PM2.5 vs tránsito: r = -0.02. Nada.

Pero la mitad de esa correlación es puro que los dos tienen ritmo diario. Cuando sacamos el ciclo diario (mirás solo las desviaciones de lo normal de cada hora):
- NO2: r = 0.20. Baja, pero existe.
- PM2.5: r = -0.02. Sigue siendo nada.

**Lo importante:** La correlación que queda es lo "real", lo que no explica la rutina de cada día.

### PASO 7: ¿Con qué demora contesta el aire?

Acá es donde pasa lo bueno. No comparamos tránsito de AHORA con aire de AHORA. Comparamos tránsito de k horas ANTES con aire de AHORA.

**NO2:**
- k=0 (ahora): r = 0.08
- k=1 hora antes: r = 0.23 (¡máximo!)
- k=2 horas antes: r = 0.20
- k=5 horas antes: r = 0.10
- k=8 horas antes: r ≈ 0

**Conclusión:** El NO2 responde en 1 hora. Es rápido, se disipa en pocas horas.

**PM2.5:**
- k=0 a k=5: correlación baja o negativa
- k=6 en adelante: empieza a subir muy lentamente
- Sigue subiendo hasta k=13-14 horas

**Conclusión:** El PM2.5 tarda 5-6 horas en empezar, pico a las 13 horas. Es lento. Se va acumulando.

### PASO 8: ¿Es real o fue por suerte?

Acá hacemos un test de aleatoriedad. Ponemos la serie de tránsito, la corremos días enteros (se rompe la relación con el aire), y calculo la correlación. Repito 50+ veces. Si la correlación real está por encima de todas las corridas al azar, no es casualidad.

**NO2:** El r real está ARRIBA de todas las barras del histograma. Ninguna corrida al azar da tan alta. **Es real.**

**PM2.5:** El r real está EN EL MEDIO de las barras. Podría haber salido por azar con rezagos cortos. No es concluyente... aún.

### PASO 9: Rezagos hasta 24 horas

**NO2:** Pico nítido en k=1, baja recta después. A las 8 horas ya casi desapareció.

**PM2.5:** Empieza a subir en k=5-6. Sube gradualmente hasta k=13-14. Mantiene una correlación moderada incluso a las 20+ horas.

**Por qué el PM2.5 de noche en PASO 4:** Tránsito de la mañana (8am) + 13 horas = 21 horas (entrada la noche). Por eso veías el pico de PM2.5 entrada la noche.

### PASO 10: El modelo (juntá todo)

Hicimos dos modelos:

**Para NO2:**
- Tránsito de hace 1 hora
- Cada 1000 vehículos extra/hora → +0.47 µg/m³ de NO2
- R² con solo lo habitual: 0.49 (explica la mitad)
- R² agregando tránsito: 0.52 (mejora un poco)

**Para PM2.5:**
- Tránsito de hace 13 horas
- Cada 1000 vehículos extra/hora → +0.07 µg/m³ de PM2.5
- R² con solo lo habitual: 0.20 (explica poco)
- R² agregando tránsito: 0.22 (casi nada cambió)

**Lo que significa R²:** Es cuánto del total explica el modelo. R²=0.5 significa explica la mitad. El resto es viento, lluvia, otras fuentes.

**Visualización:** En una semana, el modelo del NO2 sigue bastante bien lo medido. El del PM2.5 pierde los picos grandes (esos vienen de otro lado, probablemente del mar o del campo).

### PASO 11: ¿Pasa igual en otra estación?

Comparamos Tres Cruces (55 puntos de conteo cerca) con Curva de Maroñas (4 puntos):

**Tres Cruces:**
- Curva clara, máximo en k=1-2
- Supera el azar (la barra es muy alta, puntos abajo)
- Conclusión: **SÍ se ve la relación, es real**

**Curva de Maroñas:**
- Curva plana, casi nada
- No supera el azar (barra pequeña, en medio de los puntos)
- Conclusión: **No se ve. Probablemente porque solo 4 puntos no alcanza.**

**Lección clave:** No se ve la relación porque no esté. La vemos porque tenemos datos buenos que la muestren.

## Qué aprendimos

1. **El NO2 sí viene del tránsito**, y responde rápido (1 hora). Es el gas que sale del escape.

2. **El PM2.5 es complicado.** Responde lentamente (13 horas) y débilmente. Probablemente es una mezcla: tránsito, polvo, otros.

3. **La demora importa.** El aire no reacciona al tránsito de ahora. Reacciona al de hace un rato. Cada contaminante con su tiempo.

4. **Los datos de tránsito con buena cobertura geográfica son cruciales.** Sin ellos, no ves nada. Eso es verdad para cualquier análisis: medir bien es el 80% del trabajo.

5. **R² no es todo.** Un modelo explica el 50% del NO2. El otro 50% es ruido, viento, otras fuentes. Eso es realista.

