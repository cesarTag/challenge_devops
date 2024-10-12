provider "google" {
  project = var.project_id
  region  = var.region
}

module "pubsub" {
  source            = "./modules/pubsub"
  topic_name        = "data-ingestion-topic"
  subscription_name = "data-subscription"
}

module "bigquery" {
  source     = "./modules/bigquery"
  dataset_id = "analytics_dataset"
  table_id   = "analytics_table"
  region = var.region
}

module "cloudrun" {
  source = "./modules/cloudrun"
  image  = "gcr.io/${var.project_id}/data-api:latest"
  region = var.region
  project_id = var.project_id
}

