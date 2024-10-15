FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY ./app /app

# Define un argumento de construcción para las credenciales
ARG key

# Crea el archivo de credenciales en el contenedor (opcionalmente define una ubicación específica)
RUN echo "$key" > /app/credentials.json

# Define la variable de ambiente tomando el valor del argumento
ENV GOOGLE_APPLICATION_CREDENTIALS="/app/credentials.json"

# Exponemos el puerto 8080 en el contenedor
EXPOSE 8080

CMD ["sh", "-c", "gunicorn -w 2 -b 0.0.0.0:8080 main:app --env GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS"]

# Comando para ejecutar Gunicorn con 4 workers
#CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8080", "main:app", "-e", "GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS"]
