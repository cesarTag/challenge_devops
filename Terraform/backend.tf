terraform {
  backend "gcs" {
    bucket  = "terraform-bucket-challenge"
    prefix  = "terraform/state"
    credentials = "/Users/cesartag/Downloads/cuent_servicio_gcp/latam-challenge-devops-26284d5f8744.json"
  }
}