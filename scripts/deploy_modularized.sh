#!/bin/bash

# Asegurarse de que el script falle si algún comando falla
set -e

# Función para verificar si estamos en la raíz del proyecto
check_project_root() {
  cd ../
  if [ ! -f "README.md" ]; then
    echo "No estás en la raíz del proyecto."
    exit 1
  else
    echo "Estamos en la raíz del proyecto."
  fi
}

# Función para validar el entorno proporcionado
validate_environment() {
  if [ -z "$1" ]; then
    echo "Error: No se ha especificado un entorno. Usa: './deploy.sh [dev|prod]'."
    exit 1
  fi

  ENVIRONMENT=$1
  if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "prod" ]]; then
    echo "Error: Entorno inválido. Usa: './deploy.sh [dev|prod]'."
    exit 1
  fi
}

# Función para configurar las variables de entorno
load_environment_variables() {
  source .env

  if [ "$ENVIRONMENT" == "dev" ]; then
    TFVARS_FILE="$ENVIRONMENT.tfvars"
    echo "Desplegando en entorno de desarrollo."
  elif [ "$ENVIRONMENT" == "prod" ]; then
    TFVARS_FILE="Terraform/$ENVIRONMENT.tfvars"
    echo "Desplegando en entorno de producción."
  fi

  # Configurar el proyecto y la región en gcloud
  PROJECT_ID=$GCP_PROJECT_ID
  REGION=$GCP_REGION
  REPOSITORY_NAME=$GCP_CR_REPOSITORY_NAME
}

# Función para autenticarse en Google Cloud
authenticate_gcp() {
  if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "Error: La variable GOOGLE_APPLICATION_CREDENTIALS no está definida."
    exit 1
  fi

  echo "Autenticando en GCP..."
  gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
  gcloud config set project $GCP_PROJECT_ID
  gcloud config set compute/region $GCP_REGION
}

# Función para manejar el repositorio en Artifact Registry
handle_repository() {
  REPO_EXISTS=$(gcloud artifacts repositories list --location=$GCP_REGION --filter=name="projects/$GCP_PROJECT_ID/locations/$GCP_REGION/repositories/$REPOSITORY_NAME" --format="value(name)")

  if [ -z "$REPO_EXISTS" ]; then
    echo "Creando el repositorio $REPOSITORY_NAME..."
    gcloud artifacts repositories create $REPOSITORY_NAME --repository-format=docker --location=$REGION --description="Docker repository for challenge"
    echo "Repositorio creado."
  else
    echo "El repositorio $REPOSITORY_NAME ya existe."
  fi
}

# Función para construir y subir la imagen Docker
build_and_push_docker_image() {
  IMAGE_NAME="$REGION-docker.pkg.dev/$GCP_PROJECT_ID/$REPOSITORY_NAME/data-api:$ENVIRONMENT"
  echo "Construyendo la imagen Docker... $IMAGE_NAME"
  docker build --build-arg key=$(cat "$GOOGLE_APPLICATION_CREDENTIALS") -t $IMAGE_NAME ./src
  echo "Subiendo la imagen Docker..."
  gcloud auth configure-docker "$REGION-docker.pkg.dev"
  docker push $IMAGE_NAME
  echo "Imagen Docker subida: $IMAGE_NAME"
}

# Función para actualizar el archivo .tfvars
update_tfvars_file() {
  if grep -q "image = \"$IMAGE_NAME\"" "$TFVARS_FILE"; then
    echo "La línea de imagen ya existe en $TFVARS_FILE."
  else
    echo "Añadiendo la imagen al archivo $TFVARS_FILE."
    echo "image = \"$IMAGE_NAME\"" >> "$TFVARS_FILE"
  fi
}

# Función para manejar el bucket de GCS
handle_bucket() {
  BUCKET_NAME="gs://$GCP_BUCKET_NAME"
  if gsutil ls -b "$BUCKET_NAME" >/dev/null 2>&1; then
    echo "El bucket $GCP_BUCKET_NAME ya existe."
  else
    echo "Creando el bucket $BUCKET_NAME..."
    gsutil mb -l $GCP_REGION $BUCKET_NAME
    echo "Bucket creado."
  fi
}

# Función para ejecutar Terraform
run_terraform() {
  cd Terraform/
  echo "Inicializando Terraform..."
  terraform init -reconfigure
  echo "Validando Terraform..."
  terraform validate
  echo "Planificando el despliegue..."
  terraform plan -var-file="$TFVARS_FILE"
  echo "Aplicando cambios..."
  terraform apply -var-file="$TFVARS_FILE" -auto-approve
}

# Ejecutar todas las funciones en orden
check_project_root
validate_environment "$1"
load_environment_variables
authenticate_gcp
handle_repository
build_and_push_docker_image
update_tfvars_file
handle_bucket
run_terraform

echo "Despliegue completado exitosamente."
