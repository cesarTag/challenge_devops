provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file(env("GOOGLE_APPLICATION_CREDENTIALS"))

  default_tags {
    tags = {
      environment = var.gcp_profile
      owner       = "data"
      author      = "cbustamante"
      project     = "mixpanel-integration"
    }
  }
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

