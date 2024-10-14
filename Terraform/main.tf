provider "google" {
  project = var.project_id
  region  = var.region
  credentials = "/Users/cesartag/Downloads/cuent_servicio_gcp/latam-challenge-devops-26284d5f8744.json"
}


module "pubsub" {
  source            = "./modules/pubsub"
  topic_name        = var.topic_name
  subscription_name = var.subscription_name
  project_id = var.project_id

  depends_on = [
    module.bigquery.bigquery_table
  ]
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  dataset_id = var.dataset_id
  table_id   = var.table_id
  region = var.region
}

/*module "cloudrun" {
  source = "./modules/cloudrun"
  image  = var.image
  region = var.region
  project_id = var.project_id
}*/

