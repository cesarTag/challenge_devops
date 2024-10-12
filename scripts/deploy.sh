#!/bin/bash

# Asegurarse de que el script falle si algún comando falla
set -e
#nos movemos a la raiz del proyecto
cd ../
if [ ! -f "README.md" ]; then
  echo "No estás en la raíz del proyecto."
  exit 1
else
  echo "Estamos en la raíz del proyecto."
fi

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
  TFVARS_FILE="Terraform/$ENVIRONMENT.tfvars"
  echo "Desplegando en entorno de desarrollo."
elif [ "$ENVIRONMENT" == "prod" ]; then
  TFVARS_FILE="Terraform/$ENVIRONMENT.tfvars"
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

REPOSITORY_NAME=$GCP_CR_REPOSITORY_NAME

# Verificar si el repositorio ya existe
REPO_EXISTS=$(gcloud artifacts repositories list --location=$GCP_REGION --filter=name="projects/$GCP_PROJECT_ID/locations/$GCP_REGION/repositories/$REPOSITORY_NAME" --format="value(name)"
)

# Si el repositorio no existe, crearlo
if [ -z "$REPO_EXISTS" ]; then
    echo "El repositorio no existe. Creando el repositorio $REPOSITORY_NAME en $REGION..."
    gcloud artifacts repositories create $REPOSITORY_NAME \
        --repository-format=docker \
        --location=$REGION \
        --description="Docker repository for challenge"
    echo "Repositorio creado."
else
    echo "El repositorio $REPOSITORY_NAME ya existe en $REGION. No se hace nada."
fi


echo "Proyecto configurado en GCP: $PROJECT_ID"
echo "Región configurada: $REGION"
echo "Repository configurado: $REPOSITORY_NAME"

# Construcción de la imagen Docker
IMAGE_NAME="$REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/data-api:$ENVIRONMENT"
echo "Construyendo la imagen Docker para el entorno $ENVIRONMENT..."
docker build -t $IMAGE_NAME ./src

# Autenticación en Google Container Registry (GCR)
echo "Autenticando en Google Container Registry..."
gcloud auth configure-docker "$REGION-docker.pkg.dev"

# Subir la imagen Docker a GCR
echo "Subiendo la imagen Docker a Google Container Registry (GCR)..."
docker push $IMAGE_NAME

echo "Imagen Docker subida a GCR: $IMAGE_NAME"

# Reemplazar la variable de imagen en el archivo de variables (opcional)
# Si quieres que el archivo tfvars incluya la imagen:
# Verificar si la línea ya existe en el archivo
if grep -q "image = \"$IMAGE_NAME\"" "$TFVARS_FILE"; then
  echo "La línea de imagen ya existe en $TFVARS_FILE."
else
  echo "Añadiendo la línea de imagen al archivo."
  echo "image = \"$IMAGE_NAME\"" >> "$TFVARS_FILE"
fi

# Crear bucket para el backend de terraform
BUCKET_NAME="gs://$GCP_BUCKET_NAME"
BUCKET_EXISTS=$(gsutil ls -b "$BUCKET_NAME")
if [ "$BUCKET_EXISTS" = "$BUCKET_NAME/" ]; then
  echo "El bucket $GCP_BUCKET_NAME ya existe."
else
	echo "no existe el bucket, creando el bucket $BUCKET_NAME"
	gsutil mb -l $REGION $BUCKET_NAME
fi

#nos posicionamos en la carpeta de terraform
cd Terraform/
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
