## Analisis de pagina web - Escaneo Activo y Pasivo

## Descripción del proyecto
Este proyecto permite realizar un análisis básico de un host utilizando herramientas de escaneo activo y pasivo en Python.
Incluye la opción de habilitar y deshabilitar el escaneo activo, para evitar su ejecución sin autorización.

-----

## Funciones principales
-Obtención de información (Whois) del dominio.
-Resolución de registros (DNS).
-Escaneo de puertos mediante nmap (controlado).
-Consulta de HTTP mediante Requests.
-Registro de eventos y resultados en archivos '.txt' y '.log'.

-----

## Dependencias
Para hacer uso del código se necesita tener instalados los módulos externos de Python.
Se pueden instalar con el siguiente código en la terminal de tu preferencia:
pip install python-nmap python-whois dnspython requests

También se emplean módulos estándar como datetime, logging, json, y subprocess, los cuáles ya vienen incluidos con Python.

-----

## Ejecución


-----

## Modo Activo (nmap)
Para habilitar el bloque activo, edita el valor de la variable AUTHORIZED dentro del código.
AUTHORIZED = True

⚠️Nota: Los escaneos activos pueden generar tráfico detectable y, si se realizan sin autorización, podrían ser considerados intrusivos o ilegales.
Úsalo solo con fines académicos o en entornos controlados con permiso del propietario del host.

Una vez que se habilite el modo activo, el script mostrará un mensaje de advertencia en la consola.

-----

## Autores


