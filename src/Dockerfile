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
