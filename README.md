# Ekipo
Para  hacer los trabajos en equipo de progra :)

1. Extracción de eventos relevantes del Visor de eventos (registros de eventos)
Filtrado de eventos:

Use cmdlets de PowerShell para filtrar eventos por tipo (seguridad, sistema, aplicación) y por fecha. 📅

Familiarícese con el cmdlet "Get-WinEvent" para recuperar registros de eventos de forma eficaz.
Automatización de recopilación y exportación:

Automatice la recopilación de eventos filtrados y expórtelos en un formato legible como CSV, XML o HTML. 📊

Investigue el cmdlet 'Export-Csv' para exportar datos.
Identificación de actividad sospechosa:

Concéntrese en identificar eventos que puedan indicar actividad sospechosa, como intentos de inicio de sesión inusuales o cambios de configuración no autorizados. 🚨

Documente los criterios que utiliza para identificar estos eventos.
2. Correlación de procesos activos con conexiones de red
Lista de procesos activos:

Use PowerShell para enumerar los procesos activos junto con sus rutas de ejecución. 🏃‍♂️

El cmdlet 'Get-Process' será útil aquí.
Identificación de conexiones a Internet:

Identificar qué procesos tienen conexiones a Internet activas. 🌐

Use cmdlets como "Get-NetTCPConnection" y "netstat" para recopilar esta información.
Obtención de información de conexión:

Recopile detalles sobre puertos abiertos y conexiones remotas. 🔌

Correlacione cada conexión con el proceso de origen para comprender la relación entre los procesos y la actividad de la red.
Detección de procesos sospechosos:

Busque procesos que carezcan de firma digital o que se ejecuten desde ubicaciones sospechosas. 

Documente sus hallazgos y los métodos utilizados para identificar estos procesos.
3. Investigación de direcciones IP remotas mediante AbuseIPDB
Extracción de direcciones IP remotas:

De la tarea anterior, extraiga las direcciones IP remotas que se detectaron. 📋

Asegúrese de tener una lista clara de estas IP para una mayor investigación.
Comprobación de reputación de IP:

Utilice la API pública AbuseIPDB para verificar la reputación de cada dirección IP. 🔍

Investigue cómo usar 'Invoke-RestMethod' en PowerShell para realizar llamadas API.
Automatización de consultas:

Automatice el proceso de consulta desde PowerShell, lo que requerirá que comprenda cómo autenticarse con la clave API. 🔑

Documente los pasos tomados para configurar las llamadas a la API.
Clasificación IP:

Clasifique las IP según su nivel de riesgo en función de la información recuperada de AbuseIPDB. 📊

Incluya estas calificaciones en su libro blanco.


Instrucciones de la tarea: 
Crear funciones independientes para cada tarea forense, asegurándose de que tengan parámetros configurables para una mayor flexibilidad. 🔧
Combine todas las funciones en un archivo de módulo de PowerShell ('.psm1') y cree un archivo de manifiesto ('.psd1') para él. 📁
nvestigue y aplique 'Set-StrictMode -Version Latest' en todos los scripts para aplicar las mejores prácticas y detectar posibles errores temprano. ⚙️
Investigue el uso de comentarios estructurados en PowerShell y documente cada característica con ellos. 📝
Esto permitirá a los usuarios consultar la documentación con 'Get-Help'.

Crear un script maestro:
Desarrollar un script principal ('.ps1') que incluya un menú interactivo para invocar las funciones del módulo. 📜
Asegúrese de que los usuarios puedan pasar parámetros a las funciones a través de este menú.
Generar informes:
Para cada tarea forense, genere informes en formato CSV, HTML o XML. 📊
Asegúrese de que los informes estén bien organizados y sean fáciles de leer.
Incluya comentarios explicativos:
Agregue comentarios explicativos en secciones clave del código para aclarar el propósito y la funcionalidad de los bloques de código. 💬

