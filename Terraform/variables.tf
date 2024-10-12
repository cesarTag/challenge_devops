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
