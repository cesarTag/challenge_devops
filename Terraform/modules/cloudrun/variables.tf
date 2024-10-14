variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region for Cloud Run"
  type        = string
}

variable "image" {
  description = "The Docker image for the Cloud Run service"
  type        = string
}
