variable "dataset_id" {
  description = "The ID of the BigQuery dataset"
  type        = string
}

variable "table_id" {
  description = "The ID of the BigQuery table"
  type        = string
}

variable "region" {
  description = "The region for BigQuery"
  type        = string
}

variable "project_id" {
  description = "Project name in gcp"
  type        = string
}
