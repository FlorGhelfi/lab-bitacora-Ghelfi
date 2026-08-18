# =============================================================================
# BITACORA - Introduccion a Ciencia de Datos
# Fecha: 2026-08-18
# -----------------------------------------------------------------------------
# Objetivo de la actividad:
#   Tantear objetos sin verlos, registrar sus caracteristicas como variables
#   binarias (0/1) y asignarle a cada objeto una ETIQUETA (clase).
#
# Lo que se busca entender:
#   1. Que una observacion se convierte en dato solo cuando se la mide con
#      variables definidas de antemano e iguales para todos los casos.
#   2. Que las FEATURES (lo que percibe el sensor) y la ETIQUETA (lo que sabe
#      el humano) viven en planos distintos.
#   3. Que hace falta una clase "no identificado" para no forzar etiquetas.
#
# Todo el script corre en base R, sin instalar ningun paquete.
# =============================================================================


# -----------------------------------------------------------------------------
# 1. CARGA DE LOS DATOS
# -----------------------------------------------------------------------------
# Cada FILA es un objeto (una observacion) y cada COLUMNA una caracteristica
# (una variable). 1 = el objeto presenta la caracteristica, 0 = no la presenta.
# El criterio para poner 1 o 0 esta en el diccionario de variables (seccion 2).

objetos <- c("Cubo Rubik", "Lapicera", "Peluche", "Circulo de plastico",
             "Tuerca", "Cable con parte metalica", "Block de notas")

datos <- data.frame(
  # --- Geometria ---
  caras_planas      = c(1, 0, 0, 1, 1, 0, 1),
  vertices          = c(1, 0, 0, 0, 1, 0, 1),
  aristas           = c(1, 0, 0, 0, 1, 0, 1),
  forma_cubica      = c(1, 0, 0, 0, 0, 0, 0),
  forma_rectangular = c(0, 0, 0, 0, 0, 0, 1),
  forma_curva       = c(0, 1, 1, 1, 0, 1, 0),
  alargado          = c(0, 1, 0, 0, 0, 1, 0),
  plano             = c(0, 0, 0, 1, 0, 0, 1),
  simetrico         = c(1, 1, 0, 1, 1, 0, 1),
  agujero           = c(0, 0, 0, 0, 1, 0, 0),
  # --- Textura y material ---
  superficie_lisa   = c(1, 1, 0, 1, 0, 1, 0),
  superficie_rugosa = c(0, 0, 0, 0, 1, 0, 1),
  afelpado          = c(0, 0, 1, 0, 0, 0, 0),
  metalico          = c(0, 0, 0, 0, 1, 1, 0),
  plastico          = c(1, 1, 0, 1, 0, 1, 0),
  frio_al_tacto     = c(0, 0, 0, 0, 1, 1, 0),
  # --- Propiedades fisicas ---
  rigido            = c(1, 1, 0, 1, 1, 0, 0),
  deformable        = c(0, 0, 1, 0, 0, 0, 0),
  flexible          = c(0, 0, 1, 0, 0, 1, 1),
  pesado_p_tamano   = c(0, 0, 0, 0, 1, 0, 0),
  partes_moviles    = c(1, 1, 0, 0, 0, 0, 1),
  varios_materiales = c(0, 1, 1, 0, 0, 1, 1),
  row.names = objetos
)

# La ETIQUETA no se calcula a partir de las columnas de arriba: la asigna el
# observador segun lo que reconocio. "A" es la clase de los NO identificados.
etiqueta <- factor(c("Juguete", "Escritorio", "Juguete", "A - no identificado",
                     "Ferreteria", "A - no identificado", "Escritorio"))
names(etiqueta) <- objetos


# -----------------------------------------------------------------------------
# 2. DICCIONARIO DE VARIABLES
# -----------------------------------------------------------------------------
# Sin definicion operativa, dos personas etiquetan el mismo objeto distinto.
# Esto es lo que hace que el dato sea reproducible.

diccionario <- data.frame(
  variable = names(datos),
  grupo = c(rep("Geometria", 10), rep("Textura y material", 6),
            rep("Propiedades fisicas", 6)),
  definicion = c(
    "Al apoyar la palma la superficie no se curva",
    "Se sienten puntos donde se cruzan tres o mas superficies",
    "Bordes definidos y rectos al recorrer con el dedo",
    "Todos los lados de una cara miden aproximadamente lo mismo",
    "Cara con dos lados largos y dos cortos",
    "Algun contorno continuo sin quiebres",
    "Una dimension claramente mayor que las otras dos",
    "Espesor mucho menor que el ancho y el largo",
    "Se siente igual al rotarlo o darlo vuelta",
    "Se puede pasar el dedo o una punta de lado a lado",
    "El dedo se desliza sin resistencia",
    "Se sienten relieves, surcos o grano",
    "Superficie con pelo o fibra blanda",
    "Duro, frio y con sonido agudo al golpearlo",
    "Duro pero no frio, sonido opaco",
    "Al tomarlo roba calor de la mano",
    "No cambia de forma al apretarlo con la mano",
    "Se hunde al apretarlo y recupera la forma",
    "Se puede doblar sin romperse",
    "Pesa mas de lo que sugiere su volumen",
    "Alguna parte se mueve respecto del resto",
    "Se distinguen al tacto dos o mas materiales"
  ),
  stringsAsFactors = FALSE
)


# -----------------------------------------------------------------------------
# 3. EXPLORACION INICIAL
# -----------------------------------------------------------------------------

cat("\n=== DIMENSIONES DEL DATASET ===\n")
cat("Observaciones (objetos):", nrow(datos), "\n")
cat("Variables (caracteristicas):", ncol(datos), "\n")

cat("\n=== PRIMERAS FILAS (5 primeras columnas) ===\n")
print(datos[, 1:5])

cat("\n=== CONTROL DE CALIDAD ===\n")
cat("Valores faltantes:", sum(is.na(datos)), "\n")
cat("Valores distintos de 0 y 1:", sum(!as.matrix(datos) %in% c(0, 1)), "\n")


# -----------------------------------------------------------------------------
# 4. DISTRIBUCION DE LAS ETIQUETAS
# -----------------------------------------------------------------------------
# Primera pregunta de cualquier problema de clasificacion: cuantas clases hay
# y cuan balanceadas estan.

cat("\n=== FRECUENCIA DE ETIQUETAS ===\n")
frec <- table(etiqueta)
print(frec)

cat("\nProporcion (%):\n")
print(round(100 * prop.table(frec), 1))

cat("\nObjetos por etiqueta:\n")
print(split(objetos, etiqueta))


# -----------------------------------------------------------------------------
# 5. ANALISIS DE LAS VARIABLES
# -----------------------------------------------------------------------------

# Cuantos objetos presentan cada caracteristica.
suma_var <- colSums(datos)

cat("\n=== CARACTERISTICAS MAS Y MENOS FRECUENTES ===\n")
print(sort(suma_var, decreasing = TRUE))

# Una variable que vale lo mismo en TODOS los objetos no aporta informacion:
# no permite separar nada y se descarta.
constantes <- names(suma_var)[suma_var == 0 | suma_var == nrow(datos)]
cat("\nVariables sin poder discriminante:",
    if (length(constantes) == 0) "ninguna" else paste(constantes, collapse = ", "), "\n")

# Variables muy desbalanceadas (presentes en un solo objeto): describen un caso
# puntual mas que un patron general.
cat("Variables presentes en un solo objeto:",
    paste(names(suma_var)[suma_var == 1], collapse = ", "), "\n")

# Dos columnas identicas son informacion duplicada (redundancia perfecta).
cat("\n=== PARES DE VARIABLES REDUNDANTES (columnas identicas) ===\n")
m <- as.matrix(datos)
encontradas <- FALSE
for (i in 1:(ncol(m) - 1)) {
  for (j in (i + 1):ncol(m)) {
    if (all(m[, i] == m[, j])) {
      cat(" -", colnames(m)[i], "==", colnames(m)[j], "\n")
      encontradas <- TRUE
    }
  }
}
if (!encontradas) cat(" ninguna\n")


# -----------------------------------------------------------------------------
# 6. SIMILITUD ENTRE OBJETOS (indice de Jaccard)
# -----------------------------------------------------------------------------
# Para datos binarios no conviene usar distancia euclidea: los ceros compartidos
# ("ninguno de los dos tiene agujero") no deberian contar como parecido.
# Jaccard mira solo los unos: coincidencias / (coincidencias + diferencias).

jaccard <- function(a, b) {
  interseccion <- sum(a == 1 & b == 1)
  union        <- sum(a == 1 | b == 1)
  if (union == 0) return(0)
  interseccion / union
}

sim <- matrix(0, nrow = nrow(datos), ncol = nrow(datos),
              dimnames = list(objetos, objetos))
for (i in 1:nrow(datos)) {
  for (j in 1:nrow(datos)) {
    sim[i, j] <- jaccard(as.numeric(datos[i, ]), as.numeric(datos[j, ]))
  }
}

cat("\n=== MATRIZ DE SIMILITUD (Jaccard) ===\n")
print(round(sim, 2))

# Los pares mas parecidos entre si.
pares <- data.frame(
  objeto_1 = rep(objetos, each = length(objetos)),
  objeto_2 = rep(objetos, times = length(objetos)),
  similitud = as.vector(sim),
  stringsAsFactors = FALSE
)
pares <- pares[pares$objeto_1 < pares$objeto_2, ]
pares <- pares[order(-pares$similitud), ]

cat("\n=== LOS 5 PARES MAS PARECIDOS ===\n")
print(head(pares, 5), row.names = FALSE)


# -----------------------------------------------------------------------------
# 7. EL PUNTO CLAVE: LAS FEATURES NO EXPLICAN LA ETIQUETA
# -----------------------------------------------------------------------------
# Comparamos la similitud fisica promedio DENTRO de cada clase contra la
# similitud promedio ENTRE clases distintas. Si las features "explicaran" la
# etiqueta, la de adentro deberia ser bastante mayor.

pares$misma_clase <- etiqueta[pares$objeto_1] == etiqueta[pares$objeto_2]

cat("\n=== SIMILITUD PROMEDIO SEGUN LA ETIQUETA ===\n")
cat("Pares de la MISMA clase:   ",
    round(mean(pares$similitud[pares$misma_clase]), 3), "\n")
cat("Pares de clases DISTINTAS: ",
    round(mean(pares$similitud[!pares$misma_clase]), 3), "\n")

cat("\nCaso testigo - Cubo Rubik vs Peluche:\n")
cat("  Misma etiqueta:", as.character(etiqueta["Cubo Rubik"]), "\n")
cat("  Similitud fisica (Jaccard):", round(sim["Cubo Rubik", "Peluche"], 2), "\n")
cat("  -> Comparten clase sin parecerse en nada al tacto.\n")
cat("     La etiqueta la aporta el conocimiento del observador,\n")
cat("     no se deduce de las columnas medidas.\n")


# -----------------------------------------------------------------------------
# 8. VISUALIZACIONES
# -----------------------------------------------------------------------------

# 8.1 Cuantos objetos hay por etiqueta.
par(mar = c(9, 4, 4, 2))
barplot(frec,
        main = "Distribucion de etiquetas",
        ylab = "Cantidad de objetos",
        col = c("#F8CBAD", "#BDD7EE", "#FFE699", "#C6E0B4"),
        las = 2, cex.names = 0.8)

# 8.2 Mapa de calor de la matriz binaria (cada celda 0 o 1).
par(mar = c(10, 10, 4, 2))
image(1:ncol(datos), 1:nrow(datos), t(as.matrix(datos)),
      col = c("white", "#2E75B6"), axes = FALSE,
      xlab = "", ylab = "", main = "Matriz de caracteristicas (azul = 1)")
axis(1, at = 1:ncol(datos), labels = names(datos), las = 2, cex.axis = 0.65)
axis(2, at = 1:nrow(datos), labels = objetos, las = 2, cex.axis = 0.75)
box()

# 8.3 Mapa de calor de la similitud entre objetos.
par(mar = c(10, 10, 4, 2))
image(1:nrow(sim), 1:ncol(sim), sim,
      col = hcl.colors(12, "Blues", rev = TRUE), axes = FALSE,
      xlab = "", ylab = "", main = "Similitud entre objetos (Jaccard)")
axis(1, at = 1:nrow(sim), labels = objetos, las = 2, cex.axis = 0.7)
axis(2, at = 1:ncol(sim), labels = objetos, las = 2, cex.axis = 0.7)
box()

# 8.4 Agrupamiento jerarquico: que objetos se juntan si SOLO miramos features.
distancia <- as.dist(1 - sim)   # convertimos similitud en distancia
agrupamiento <- hclust(distancia, method = "average")

par(mar = c(10, 4, 4, 2))
plot(agrupamiento,
     main = "Agrupamiento por caracteristicas fisicas",
     sub = "", xlab = "", ylab = "Distancia (1 - Jaccard)")

# Comparamos los grupos que salen de los datos contra las etiquetas reales.
grupos_datos <- cutree(agrupamiento, k = length(levels(etiqueta)))

cat("\n=== GRUPOS SEGUN LOS DATOS vs ETIQUETAS REALES ===\n")
print(table(grupo_calculado = grupos_datos, etiqueta_real = etiqueta))
cat("\nSi la tabla no es diagonal, los grupos que surgen de las features\n")
cat("no coinciden con las clases que asigno el observador.\n")

par(mar = c(5, 4, 4, 2))   # dejamos los margenes como estaban


# -----------------------------------------------------------------------------
# 9. EXPORTACION
# -----------------------------------------------------------------------------
# Guardamos el dataset final con la etiqueta como una columna mas.

dataset_final <- cbind(objeto = objetos, datos, etiqueta = as.character(etiqueta))
write.csv(dataset_final, "objetos_tacto.csv", row.names = FALSE)
write.csv(diccionario, "diccionario_variables.csv", row.names = FALSE)

cat("\nArchivos exportados: objetos_tacto.csv y diccionario_variables.csv\n")


# =============================================================================
# CONCLUSIONES DE LA BITACORA
# =============================================================================
#
# 1. Un dato no es lo que se percibe, sino lo que se registra.
#    "Es rugoso" no es dato hasta que existe una variable con una definicion
#    operativa que diga que cuenta como rugoso y que no.
#
# 2. Las variables tienen que ser las mismas para todos los casos.
#    Aunque el valor sea 0. Si a cada objeto se lo describe con las variables
#    que a uno le parecen, despues no se puede comparar nada.
#
# 3. La eleccion de las variables sesga el resultado.
#    El total por fila no mide "complejidad del objeto": mide cuantas de las
#    variables que YO elegi tiene ese objeto. Con mas columnas de geometria,
#    los objetos angulares parecen mas ricos de lo que son.
#
# 4. Hay variables que no sirven y variables duplicadas.
#    Una columna constante no separa nada. Dos columnas identicas
#    (metalico y frio_al_tacto) aportan la misma informacion una sola vez.
#
# 5. Features y etiqueta son cosas distintas.
#    Las features salen del sensor (la mano); la etiqueta sale del conocimiento
#    del observador. El Rubik y el peluche tienen similitud 0 al tacto y
#    comparten etiqueta "Juguete". Esa brecha es exactamente el problema que
#    intenta resolver el aprendizaje supervisado.
#
# 6. La clase "A - no identificado" es una clase legitima.
#    Existe para no forzar etiquetas. Un "no se" honesto es un dato valido;
#    una etiqueta inventada es ruido que despues contamina todo el analisis.
#
# 7. La confiabilidad depende del diccionario.
#    Si dos companeros etiquetan el mismo objeto distinto, el problema no esta
#    en ellos sino en que la definicion de la variable era ambigua.
#
# =============================================================================
