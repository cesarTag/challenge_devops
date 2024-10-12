variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = env("GCP_PROJECT_ID")
}

variable "region" {
  description = "Region where the resources will be created"
  type        = string
  default     = env("GCP_REGION")
}

variable "gcp_profile" {
  default = "development"
}
