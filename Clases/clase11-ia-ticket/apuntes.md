# Leer un ticket con IA — Clase 11

## La idea

Tenemos una foto de un ticket de compra. Quiero saber qué compré y cuánto gasté. Lo obvio es abrirlo, leerlo a mano y transcribir. Lo de hoy: mandárselo a una IA y que lo haga automáticamente.

Es OCR, pero sin tener que escribir el código que detecta letras. Google (Gemini) y Groq ya lo tienen hecho.

## Qué pasó paso a paso

Tomamos la foto del ticket (45 KB de bytes). Eso es un archivo binario. Una IA no entiende bytes directamente cuando le mandás un JSON. Necesita texto.

Ahí entra base64. Es una forma de codificar cualquier archivo (imagen, video, lo que sea) en texto puro. Cada 3 bytes del archivo se convierten en 4 caracteres. La foto se convirtió en 60.520 caracteres de base64. Es solo una forma de pasar la información.

Armamos un JSON con dos partes: la instrucción (transcribí los ítems, dame un CSV) y la foto en base64. Se lo mandamos a Gemini por HTTPS.

Gemini lee la foto, entiende que es un ticket, ve qué dice, y devuelve un CSV limpio. Dos items: leche fresca 18 pesos, pan francés 32 pesos.

Guardamos eso en un archivo CSV y lo abrimos con read.csv. La suma da 50, que es exactamente el total del ticket.

## Qué significa para la realidad

Durante años la gente hacía OCR con código: librerías que detectaban letras, cifras, se equivocaban, había que corregir. Ahora mandás una foto a una IA y listo.

Un supermercado podría mandar todas sus facturas a Gemini y extraer los datos automáticamente en un segundo. Una empresa de logística podría leer albaranes. Una contadora podría automatizar la carga de facturas.

La IA no siempre lee perfecto, pero lee lo suficiente como para ahorrarte el 90% del trabajo. Si no entiende algo, lo deja en blanco. Vos ves qué falta y lo corregís, pero la mayoría de casos sale sin tocar.

## Por qué se quedó en 50 en lugar de 48.36

El total de la foto era 48.36, pero pedimos que no incluyera SUBTOTAL, IVA, TOTAL, EFECTIVO, CAMBIO. La IA extrajo solo los items (18 + 32 = 50). Eso es lo que pedimos y eso es lo que devolvió. Si hubiéramos querido el total final, había que cambiar la instrucción.

## Lo importante

No escribiste un algoritmo que detecta texto en imágenes. Mandamos una foto a una URL con una clave. Gemini hace el trabajo pesado. Yo uso el resultado. Eso es usar IA hoy en día.

La clave es que Google y Groq tienen esas APIs publicas y gratis (con límites). Si necesitamos procesar muchos tickets, pagas. Si necesitás procesar algunos, es gratis. Para una clase o un prototipo, es perfecto.