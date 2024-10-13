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

resource "google_project_iam_member" "run_bigquery_access" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_cloud_run_service.service.project}"
}
