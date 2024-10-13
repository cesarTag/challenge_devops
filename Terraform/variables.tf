variable "project_id" {
  type        = string
  description = "ID del proyecto de Google Cloud"
}

variable "region" {
  description = "Region where the resources will be created"
  type        = string
}

variable "gcp_profile" {
  default = "development"
}

variable "credentials_path" {
  description = "The path to your Google Cloud service account credentials JSON file"
}

variable "dataset_id" {
  description = "Nombre del dataset a crear en BigQuery"
  type        = string
}

variable "table_id" {
  description = "Nombre de la tabla a crear en BigQuery"
  type        = string
}

variable "image" {
  description = "Nombre de la imagen docker generada"
  type        = string
}

variable "subscription_name" {
  description = "Nombre de la suscripcion al topico"
  default = ""
}

variable "topic_name" {
  description = "Nombre de la suscripcion al topico"
  default = ""
}
