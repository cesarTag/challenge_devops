##Documentación de la API
Este proyecto implementa una aplicación web que expone un endpoint para recuperar datos de una tabla en Google BigQuery. A continuación, se describen los detalles de cada componente involucrado.

````bash
src/
│                             
├── app/
│   ├── main.py               # Archivo principal de la aplicación Flask
│   ├── bigquery_handler.py    # Módulo que maneja la interacción con BigQuery
│                              # Archivo principal de la aplicación Flask
├── Dockerfile                # Archivo para crear la imagen Docker
│
└── tests/                     # Directorio de pruebas
│   ├── unit              
│   ├── integration
````

El archivo ```main.py``` define una aplicación web utilizando el framework Flask. Expone un solo endpoint (/data) que realiza una consulta a BigQuery y devuelve los resultados en formato JSON.

###Dependencias
**Flask:** Framework utilizado para manejar el servidor HTTP y las rutas.

**logging:** Módulo estándar de Python para manejar el registro de logs.

**bigquery_handler:** Módulo que contiene la lógica para realizar consultas a BigQuery.

###Funciones Principales
**get_data()**

**Ruta:** /data

**Método:** GET

**Descripción:**
Esta función es el handler del endpoint /data. Llama a la función get_data_from_bigquery (definida en bigquery_handler.py) para recuperar los datos de BigQuery y los devuelve en formato JSON. En caso de error, registra el problema y responde con un mensaje de error en formato JSON.

###Ejecución
Cuando se ejecuta el archivo directamente, el servidor Flask corre en modo de desarrollo en el puerto 8080.
`````bash
$ python src/app/main.py
`````
Si el archivo es cargado por un servidor externo como Gunicorn, ajusta la configuración de los logs para integrarse con el sistema de logging de Gunicorn.
```bash
$ gunicorn -w 4 -b 0.0.0.0:8080 'main:app'
```

El archivo `bigquery_handler.py` maneja la interacción con Google BigQuery, ejecutando una consulta y devolviendo los resultados.

###Dependencias
**google.cloud.bigquery:** Librería oficial de Google para interactuar con BigQuery.

**google.oauth2.service_account:** Para autenticarse mediante credenciales de servicio.

**os:** Para acceder a las variables de entorno.

###Variables de Entorno
**GOOGLE_APPLICATION_CREDENTIALS:** Variable de entorno que debe contener la ruta al archivo de credenciales del servicio.

**Descripción:** Ejecuta una consulta SQL en una tabla de BigQuery y devuelve los primeros 10 registros.

**Excepciones:**
Si hay algún problema al obtener los datos, se lanza una excepción de tipo RuntimeError.

###Dockerfile
El archivo Dockerfile proporciona las instrucciones para construir una imagen Docker que ejecuta la aplicación Flask utilizando Gunicorn como servidor WSGI.

````hcl
FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Establecemos la variable de entorno para la ubicación de las credenciales
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/cuent_servicio_gcp/latam-challenge-devops-26284d5f8744.json

# Exponemos el puerto 8080 en el contenedor
EXPOSE 8080

#CMD ["python", "app/main.py"]

# Comando para ejecutar Gunicorn con 4 workers
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8080", "main:app"]
````


