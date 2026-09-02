# =============================================================================
# Bitacora - Introduccion a Ciencia de Datos
# Tipos de variables
# 18/08/2026
# =============================================================================

# VARIABLES BINARIAS: solo 2 opciones posibles
# Ejemplos: si/no, verdadero/falso, masculino/femenino,
#           vivo/muerto, estudia/no estudia

estudia <- c("Si", "No", "Si", "Si", "No", "Si", "Si", "No", "Si", "Si")
sexo    <- c("F", "M", "F", "F", "M", "M", "F", "M", "F", "F")

table(estudia)
table(sexo)


# VARIABLES CATEGORICAS: varias opciones posibles
# Ejemplos: pais, universidad, carrera, color

pais <- c("Uruguay", "Argentina", "Uruguay", "Brasil", "Uruguay",
          "Argentina", "Uruguay", "Chile", "Brasil", "Uruguay")

universidad <- c("UM", "UdelaR", "UM", "ORT", "UM",
                 "UdelaR", "ORT", "UM", "UdelaR", "UM")

table(pais)
table(universidad)


# CONTAR ES LO QUE SE HACE CON ESTAS VARIABLES ------------------------------
# No tiene sentido sacar promedios: no existe un "pais promedio".

table(pais)                      # cuantos hay de cada uno
prop.table(table(pais))          # en proporcion
round(100 * prop.table(table(pais)), 1)   # en porcentaje


# GRAFICO DE BARRAS ---------------------------------------------------------

barplot(table(pais),
        main = "Estudiantes por pais",
        col = "steelblue",
        las = 2)

barplot(table(estudia),
        main = "Estudia?",
        col = c("tomato", "seagreen"))


# CRUZAR DOS VARIABLES ------------------------------------------------------

table(pais, estudia)


# =============================================================================
# RESUMEN
#
# Binaria    -> 2 categorias      (si/no, vivo/muerto, estudia/no estudia)
# Categorica -> varias categorias (pais, universidad)
#
# Con las dos se cuenta (table) y se grafica con barras (barplot).
# No se promedian.
# =============================================================================
