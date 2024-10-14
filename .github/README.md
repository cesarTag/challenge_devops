# CI/CD Pipelines

Este proyecto utiliza ``github actions`` para implementar practica de Integracion y Despliegue Continuo (CI/CD).

###1. Archivo para CI (Integración Continua)
    .github/workflows/ci.yml

Este archivo se encargará de la parte de integración continua, donde se verifica la calidad del código, se ejecutan las pruebas unitarias, y se asegura que el código esté listo para el despliegue.
```yml
name: CI Pipeline

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Set up Python environment
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt

    - name: Lint Code
      run: |
        pip install flake8
        flake8 .

    - name: Run Unit Tests
      run: |
        pip install pytest
        pytest

    - name: Upload Test Results
      if: always()
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: test-results/

    - name: Verify Terraform Formatting
      run: |
        terraform fmt -check

    - name: Initialize and Validate Terraform
      run: |
        terraform init -backend=false
        terraform validate

```
###**Explicación:**

**Eventos:** El pipeline se ejecuta cuando hay un push a la rama main o cuando se crea un pull_request.

**Checkout del código:** El código se descarga utilizando actions/checkout.

**Configuración de Python:** Se establece un entorno Python para la ejecución de pruebas unitarias y la instalación de dependencias.

**Linting:** Se asegura la calidad del código usando flake8.

**Pruebas Unitarias:** Se ejecutan pruebas utilizando pytest.

**Terraform:** Se verifica el formato y la validación de los archivos de Terraform sin ejecutar ningún cambio de infraestructura.


###2. Archivo para CD (Despliegue Continuo): 
    .github/workflows/cd.yml
Este archivo está diseñado para realizar el despliegue continuo en GCP utilizando Docker, Terraform y otros recursos de GCP.
```yml
name: CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Set up Google Cloud SDK
      uses: google-github-actions/setup-gcloud@v1
      with:
        project_id: ${{ secrets.GCP_PROJECT_ID }}
        service_account_key: ${{ secrets.GCP_SA_KEY }}
        export_default_credentials: true

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Configure Docker to use gcloud as a credential helper
      run: |
        gcloud auth configure-docker "${{ secrets.GCP_REGION }}-docker.pkg.dev"

    - name: Build Docker image
      run: |
        IMAGE_NAME="${{ secrets.GCP_REGION }}-docker.pkg.dev/${{ secrets.GCP_PROJECT_ID }}/${{ secrets.GCP_CR_REPOSITORY_NAME }}/data-api:latest"
        docker build -t $IMAGE_NAME ./src
        docker push $IMAGE_NAME

    - name: Update Terraform .tfvars file with Docker image
      run: |
        echo 'image = "${{ secrets.GCP_REGION }}-docker.pkg.dev/${{ secrets.GCP_PROJECT_ID }}/${{ secrets.GCP_CR_REPOSITORY_NAME }}/data-api:latest"' >> Terraform/prod.tfvars

    - name: Initialize Terraform
      run: |
        cd Terraform
        terraform init

    - name: Apply Terraform Changes
      run: |
        terraform apply -var-file="prod.tfvars" -auto-approve

```

###**Explicación:**

**Eventos:** El pipeline se activa al hacer push en la rama main (por ejemplo, después de pasar la integración continua).

**Checkout del código:** Se descarga el código utilizando actions/checkout.

**Autenticación en Google Cloud:** Utiliza el plugin de GitHub Actions para autenticarse en Google Cloud con las credenciales del proyecto y la cuenta de servicio almacenadas en los secrets.

**Configuración de Docker:** Prepara Docker para la compilación de la imagen y la autenticación en Artifact Registry.

**Construcción y publicación de Docker:** La imagen Docker se construye a partir del código fuente en ./src y se sube a Artifact Registry de GCP.

**Actualización de Terraform:** El archivo .tfvars se actualiza automáticamente con la imagen Docker recién generada.

**Terraform Init y Apply:** Se ejecuta Terraform para desplegar la infraestructura y servicios en Google Cloud.


###Prácticas Implementadas:
**Separación de CI y CD:** El proceso de integración continua y despliegue continuo está claramente separado para evitar que fallos de construcción o pruebas afecten el despliegue.

**Modularidad:** Cada tarea está dividida en pequeños pasos manejables, desde la autenticación hasta la construcción y despliegue de recursos.

**Reutilización de secretos:** Los secretos como GCP_PROJECT_ID, GCP_SA_KEY, GCP_REGION, GCP_CR_REPOSITORY_NAME se almacenan en GitHub Actions Secrets, evitando exponer credenciales en el código.

**Validaciones de Terraform en CI:** La configuración de Terraform se valida antes de aplicar los cambios en CD, evitando posibles fallos en el despliegue.

**Automatización de la actualización de .tfvars:** La actualización de la imagen en el archivo .tfvars se realiza automáticamente en el flujo de CD, asegurando que el despliegue use siempre la última imagen.

###Requerimientos Previos:
**GitHub Secrets Configurados:** Se deben configurar los siguientes secrets en GitHub para que funcione la autenticación y el despliegue:

**GCP_PROJECT_ID:** ID del proyecto de Google Cloud.

**GCP_SA_KEY:** Clave de la cuenta de servicio de GCP en formato JSON.

**GCP_REGION:** Región de GCP donde se realizará el despliegue.

**GCP_CR_REPOSITORY_NAME:** Nombre del repositorio de Artifact Registry donde se subirá la imagen Docker.

### Descripción de los Archivos:

- **`ci.yml`**: Encargado de la Integración Continua. Verifica la calidad del código y valida la infraestructura con Terraform.
- **`cd.yml`**: Maneja el proceso de Despliegue Continuo. Construye y despliega la imagen Docker, actualiza la infraestructura usando Terraform, y ejecuta los cambios en Google Cloud.

### Ejecutando CI/CD

1. Cada vez que se realiza un `push` o un `pull request` a la rama `main`, el pipeline de CI se ejecutará automáticamente para validar los cambios.
2. Cuando se realiza un `push` a la rama `main`, el pipeline de CD se encargará de desplegar los cambios en el entorno de producción usando los recursos de Google Cloud.

### Notas

- Asegúrate de que las herramientas necesarias como `Docker`, `Terraform`, y `Google Cloud SDK` estén instaladas correctamente en tu entorno local para hacer pruebas manuales.
- El pipeline de CD actualiza automáticamente el archivo `.tfvars` con la última versión de la imagen Docker generada para asegurar que los despliegues siempre usen la última imagen.

## Licencia

Este proyecto está licenciado bajo los términos de [MIT License](LICENSE).