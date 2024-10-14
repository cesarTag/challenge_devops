# Script de Despliegue: `deploy_modularized.sh`

Este script automatiza el proceso de despliegue desde un ambiente local de desarrollo de una infraestructura en Google Cloud Platform (GCP) utilizando Docker, Artifact Registry, Google Cloud Storage (GCS) y Terraform. Está diseñado para ser ejecutado en entornos de desarrollo o producción y maneja todos los pasos necesarios para construir y desplegar una aplicación.

## Prerrequisitos

Antes de ejecutar el script, asegúrate de cumplir con los siguientes requisitos:

1. **Google Cloud SDK**: El comando `gcloud` debe estar instalado y configurado en tu entorno. [Instrucciones de instalación](https://cloud.google.com/sdk/docs/install).
2. **Credenciales de GCP**: Un archivo de credenciales de la cuenta de servicio debe estar disponible, y la variable de entorno `GOOGLE_APPLICATION_CREDENTIALS` debe apuntar a su ubicación.
3. **Docker**: Docker debe estar instalado para construir y subir la imagen.
4. **Terraform**: Terraform debe estar instalado y configurado. [Instrucciones de instalación](https://learn.hashicorp.com/tutorials/terraform/install-cli).
5. **Archivo `.env`**: Un archivo `.env` debe estar presente en la raíz del proyecto, con las siguientes variables:
   - `GCP_PROJECT_ID`: El ID del proyecto de GCP.
   - `GCP_REGION`: La región de GCP donde se desplegarán los recursos.
   - `GCP_CR_REPOSITORY_NAME`: Nombre del repositorio de Docker en Artifact Registry.
   - `GCP_BUCKET_NAME`: Nombre del bucket de Google Cloud Storage.

## Uso

El script debe ser ejecutado desde la raíz del proyecto. Para usarlo, sigue los siguientes pasos:

1. **Proporcionar el entorno**: El entorno debe ser especificado como argumento al ejecutar el script. Los entornos válidos son `dev` (desarrollo) y `prod` (producción).

    ```bash
    ./deploy.sh [dev|prod]
    ```

### Ejemplos:

- Desplegar en desarrollo:

    ```bash
    ./deploy.sh dev
    ```

- Desplegar en producción:

    ```bash
    ./deploy.sh prod
    ```

## Funciones del Script

El script consta de varias funciones que manejan las diferentes tareas necesarias para el despliegue. A continuación, se detallan estas funciones:

### 1. **check_project_root**

Verifica que el script se está ejecutando desde la raíz del proyecto al comprobar la existencia de un archivo `README.md`. Si no está presente, el script fallará.

### 2. **validate_environment**

Valida que se haya proporcionado un entorno (`dev` o `prod`) como argumento al ejecutar el script. Si no se especifica o es inválido, el script fallará.

### 3. **load_environment_variables**

Carga las variables de entorno desde el archivo `.env` y configura las variables necesarias para el despliegue en función del entorno (`dev` o `prod`).

### 4. **authenticate_gcp**

Autentica el acceso a Google Cloud utilizando las credenciales de la cuenta de servicio definidas en la variable de entorno `GOOGLE_APPLICATION_CREDENTIALS`.

### 5. **handle_repository**

Comprueba si el repositorio de Docker en Artifact Registry ya existe. Si no existe, lo crea. Este repositorio es utilizado para almacenar la imagen Docker construida.

### 6. **build_and_push_docker_image**

Construye la imagen Docker a partir del código en la carpeta `./src` y la sube al repositorio de Artifact Registry en GCP.

### 7. **update_tfvars_file**

Actualiza el archivo `.tfvars` correspondiente al entorno con la URL de la imagen Docker generada para que sea utilizada por Terraform en el despliegue.

### 8. **handle_bucket**

Verifica si el bucket de Google Cloud Storage ya existe. Si no, lo crea en la región especificada en el archivo `.env`.

### 9. **run_terraform**

Inicializa y ejecuta Terraform para aplicar los cambios de infraestructura. Este paso realiza la validación, planificación y aplicación de los cambios necesarios para el despliegue en el entorno proporcionado.

## Detalles Técnicos

### Variables de entorno requeridas

El archivo `.env` debe contener las siguientes variables:

- `GCP_PROJECT_ID`: El ID del proyecto de Google Cloud.
- `GCP_REGION`: La región de Google Cloud en la que se crearán los recursos.
- `GCP_CR_REPOSITORY_NAME`: Nombre del repositorio de Docker en Google Artifact Registry.
- `GCP_BUCKET_NAME`: Nombre del bucket de Google Cloud Storage.
- `GOOGLE_APPLICATION_CREDENTIALS`: Ruta al archivo de credenciales de la cuenta de servicio de Google Cloud.

### Terraform

Este script asume que la infraestructura se gestiona con Terraform. Se espera que existan los archivos de configuración de Terraform en la carpeta `Terraform/`, y que los archivos `.tfvars` para los entornos `dev` y `prod` estén presentes.

### Docker

El script utiliza Docker para construir la imagen de la aplicación desde el código fuente ubicado en `./src`. La imagen se sube al repositorio de Artifact Registry en GCP.

## Notas adicionales

- **Errores comunes**: 
  - Asegúrate de que el archivo `.env` esté correctamente configurado.
  - Verifica que las credenciales de GCP estén bien configuradas en la variable `GOOGLE_APPLICATION_CREDENTIALS`.
  - Si Docker no está configurado para autenticarse con Artifact Registry, el comando `gcloud auth configure-docker` configurará automáticamente el acceso.

- **Ejecución fallida**: Si el script falla en cualquier punto, se detendrá gracias a la instrucción `set -e`, que asegura que el script falle si cualquier comando falla.

## Licencia

Este proyecto está licenciado bajo los términos de [MIT License](LICENSE).
