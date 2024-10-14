# Terraform GCP Infrastructure

Este proyecto utiliza Terraform para implementar una infraestructura en Google Cloud Platform (GCP) que incluye los siguientes componentes:

- **Google Pub/Sub**: Para la ingesta de datos en un sistema de mensajería en tiempo real.
- **BigQuery**: Para el almacenamiento analítico de los datos ingeridos.
- **Cloud Run** (comentado en este archivo, pero potencialmente disponible para ejecutar aplicaciones en contenedores).

## Prerrequisitos

1. **Cuenta de servicio de GCP**: Necesitas una cuenta de servicio de GCP con permisos para gestionar los recursos de Pub/Sub, BigQuery y Cloud Run (si se va a usar).
2. **Archivo de credenciales**: El archivo de credenciales de la cuenta de servicio debe estar accesible en tu máquina. En este ejemplo, se encuentra en `/Users/cesartag/Downloads/cuent_servicio_gcp/latam-challenge-devops-26284d5f8744.json`.
3. **Terraform**: Asegúrate de tener Terraform instalado en tu sistema. [Instrucciones de instalación](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## Variables

Este archivo de Terraform utiliza variables para facilitar la personalización. Asegúrate de definir las siguientes variables en tu archivo `terraform.tfvars` o mediante otro mecanismo (p. ej., variables de entorno o archivo de variables específicas).

- `project_id`: ID del proyecto de GCP.
- `region`: Región en la que se implementarán los recursos.
- `topic_name`: Nombre del tema de Pub/Sub.
- `subscription_name`: Nombre de la suscripción de Pub/Sub.
- `dataset_id`: ID del dataset de BigQuery.
- `table_id`: ID de la tabla de BigQuery.
- `image`: (Opcional) URL de la imagen de contenedor para ejecutar en Cloud Run (si es que se habilita este servicio).

### Ejemplo de archivo `terraform.tfvars`

Puedes definir las variables de tu proyecto en un archivo `terraform.tfvars` o exportarlas como variables de entorno para que Terraform las utilice. A continuación se muestra un ejemplo:

```hcl
project_id        = "my-gcp-project-id"
region            = "us-central1"
credentials_path  = "/Users/tu_usuario/path/al/archivo/credenciales.json"
dataset_id        = "mi_dataset"
table_id          = "mi_tabla"
topic_name        = "mi_topic"
subscription_name = "mi_suscripcion"
image             = "gcr.io/my-gcp-project-id/my-docker-image"
```


## Gestión del Estado de Terraform

Este proyecto utiliza Google Cloud Storage (GCS) como backend remoto para gestionar el estado de Terraform. Esto permite almacenar el estado de forma segura y colaborativa en la nube, lo que es especialmente útil cuando varios usuarios trabajan en la misma infraestructura.

### Configuración del Backend

En el archivo `backend.tf` se especifica el uso de un bucket en GCS para almacenar el estado de Terraform:

```hcl
terraform {
  backend "gcs" {
    bucket      = "terraform-bucket-challenge"
    prefix      = "terraform/state"
    credentials = "/ruta/a/tu/archivo/credenciales.json"
  }
}
```
### Explicación de los parámetros:
**bucket:** Nombre del bucket de GCS donde se almacenará el estado remoto.

**prefix:** Carpeta dentro del bucket donde se almacenará el archivo de estado.

**credentials:** Ruta al archivo de credenciales de GCP que Terraform utilizará para acceder al bucket de GCS.

###Beneficios del Backend Remoto
**Colaboración:** Permite que múltiples miembros del equipo trabajen en la misma infraestructura compartiendo el estado.

**Persistencia:** El estado de Terraform se almacena de forma segura y no depende del entorno local.

**Bloqueo de Estado:** GCS soporta el bloqueo de estado para evitar que varios usuarios realicen cambios simultáneos en la infraestructura, previniendo posibles errores de concurrencia.

## Estructura del Módulo

### Provider

El proveedor de Google se configura utilizando las credenciales de la cuenta de servicio y el proyecto proporcionado. Ejemplo:

```hcl
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = "/ruta/a/tu/archivo/credenciales.json"
}
```

### Módulo Pub/Sub
Este módulo configura un tema y una suscripción de Pub/Sub en el proyecto de GCP especificado. Está diseñado para depender de la existencia de una tabla en BigQuery (definida en el módulo BigQuery).
```hcl
module "pubsub" {
  source            = "./modules/pubsub"
  topic_name        = var.topic_name
  subscription_name = var.subscription_name
  project_id        = var.project_id

  depends_on = [
    module.bigquery.bigquery_table
  ]
}
```

### Módulo BigQuery
Este módulo configura un dataset y una tabla en BigQuery en el proyecto de GCP. Se especifican el dataset_id y el table_id que se deben crear o utilizar.
```hcl
module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  dataset_id = var.dataset_id
  table_id   = var.table_id
  region     = var.region
}
```

### Módulo Cloud Run (comentado)
Este módulo está comentado en el archivo actual, pero se puede habilitar para implementar un servicio en Cloud Run basado en una imagen de contenedor específica. Asegúrate de definir la variable image si deseas habilitar este servicio.
```hcl
module "cloudrun" {
  source     = "./modules/cloudrun"
  image      = var.image
  region     = var.region
  project_id = var.project_id
}
```

### Outputs
El archivo outputs.tf está preparado para devolver la URL del servicio de Cloud Run.
```hcl
module "cloudrun" {
  source     = "./modules/cloudrun"
  image      = var.image
  region     = var.region
  project_id = var.project_id
}
```
### Descripción de la salida:
**cloud_run_url:** Si se despliega el servicio en Cloud Run, esta salida devuelve la URL del servicio, permitiendo acceder fácilmente a la aplicación desplegada.

### Cómo utilizar este archivo Terraform

1. Clona el repositorio y navega a la carpeta del proyecto.

2. Asegúrate de tener el archivo de credenciales adecuado y las variables definidas en un archivo terraform.tfvars o exportadas como variables de entorno.

3. Inicializa el entorno de Terraform:
````bash
terraform init
````
4. Revisa el plan de ejecución:
````bash
terraform plan
````
5. Aplica los cambios para desplegar la infraestructura:
````bash
terraform apply
````

### Notas adicionales
- El archivo de credenciales debe ser protegido adecuadamente. 
- No incluyas este archivo en ningún repositorio público.
- Asegúrate de tener las APIs necesarias habilitadas en GCP, como la API de Pub/Sub, BigQuery y Cloud Run (si aplica).

###Licencia
Este proyecto está licenciado bajo los términos de MIT License.