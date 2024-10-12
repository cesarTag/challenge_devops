#!/bin/bash

# Asegurarse de que el script falle si algún comando falla
set -e
#nos movemos a la raiz del proyecto
cd ../

# Asegurarse de que se proporciona un entorno válido
if [ -z "$1" ]; then
  echo "Error: No se ha especificado un entorno. Usa: './deploy.sh [dev|prod]'."
  exit 1
fi

# Verificar si el entorno es válido (solo permitimos 'dev' o 'prod')
ENVIRONMENT=$1
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "prod" ]]; then
  echo "Error: Entorno inválido. Usa: './deploy.sh [dev|prod]'."
  exit 1
fi

# Cargar variables de ambiente definidas en el archivo .env
source .env

# Definir el archivo de variables de entorno basado en el entorno proporcionado
if [ "$ENVIRONMENT" == "dev" ]; then
  TFVARS_FILE="Terraform/dev.tfvars"
  echo "Desplegando en entorno de desarrollo."
elif [ "$ENVIRONMENT" == "prod" ]; then
  TFVARS_FILE="Terraform/prod.tfvars"
  echo "Desplegando en entorno de producción."
fi

# Autenticación con Google Cloud
# Asegúrate de que GOOGLE_APPLICATION_CREDENTIALS apunte al archivo correcto
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
  echo "Error: La variable GOOGLE_APPLICATION_CREDENTIALS no está definida. Asegúrate de que apunta a tu archivo de credenciales JSON."
  exit 1
fi

echo "Autenticando en GCP con la cuenta de servicio definida en GOOGLE_APPLICATION_CREDENTIALS."
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

# Configurar el proyecto y la región en gcloud
PROJECT_ID=$GCP_PROJECT_ID
gcloud config set project $PROJECT_ID

REGION=$GCP_REGION
gcloud config set compute/region $REGION

echo "Proyecto configurado en GCP: $PROJECT_ID"
echo "Región configurada: $REGION"

# Construcción de la imagen Docker
IMAGE_NAME="gcr.io/$PROJECT_ID/data-api:$ENVIRONMENT"

echo "Construyendo la imagen Docker para el entorno $ENVIRONMENT..."
docker build -t $IMAGE_NAME ./src

# Autenticación en Google Container Registry (GCR)
echo "Autenticando en Google Container Registry..."
gcloud auth configure-docker

# Subir la imagen Docker a GCR
echo "Subiendo la imagen Docker a Google Container Registry (GCR)..."
docker push $IMAGE_NAME

echo "Imagen Docker subida a GCR: $IMAGE_NAME"

# Reemplazar la variable de imagen en el archivo de variables (opcional)
# Si quieres que el archivo tfvars incluya la imagen:
echo "image = \"$IMAGE_NAME\"" >> $TFVARS_FILE

# Inicializar Terraform
echo "Inicializando Terraform..."
terraform init

# Planear el despliegue con las variables del entorno adecuado
echo "Planificando el despliegue para el entorno $ENVIRONMENT..."
terraform plan -var-file="$TFVARS_FILE"

# Aplicar el despliegue
echo "Aplicando cambios para el entorno $ENVIRONMENT..."
terraform apply -var-file="$TFVARS_FILE" -auto-approve

echo "Despliegue completado exitosamente en el entorno $ENVIRONMENT."
