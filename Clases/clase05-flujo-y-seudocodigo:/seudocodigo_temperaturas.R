###INICIO Filtrar_Temperaturas

##// 1. Crear el vector con datos
#DEFINIR temperaturas = [18, 22, 15, 25, 30]
temperaturas <- c(18, 22, 15, 25, 30)

##// 2. Filtrar elementos mayores a 20
#CREAR vector_filtrado VACÍO

#PARA CADA temp EN temperaturas
#SI temp > 20 ENTONCES
#AGREGAR temp A vector_filtrado
vector_filtrado <- temperaturas[temperaturas>20]

#FIN SI
#FIN PARA

#IMPRIMIR vector_filtrado
print(vector_filtrado)

#FIN Filtrar_Temperaturas