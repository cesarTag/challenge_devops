resource "google_cloud_run_service" "service" {
  name     = "data-api-service"
  location = var.region

  template {
    spec {
      containers {
        image = var.image

      }
    }
  }
}

data "google_project" "project" {
}

resource "google_project_iam_member" "run_bigquery_access" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service    = google_cloud_run_service.service.name
  location   = google_cloud_run_service.service.location
  role       = "roles/run.invoker"
  member     = "allUsers"  # Permite acceso público
}
