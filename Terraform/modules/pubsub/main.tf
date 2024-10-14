resource "google_pubsub_topic" "topic" {
  name = var.topic_name
}

resource "google_pubsub_subscription" "bigquery_subscription" {
  name  = var.subscription_name
  topic = google_pubsub_topic.topic.id
  project = var.project_id
  labels  = var.subscription_labels
  ack_deadline_seconds = var.ack
  message_retention_duration = var.message_retention

  bigquery_config {
    table = "latam-challenge-devops.dataset_challenge.table_challenge"
  }

  depends_on = [google_project_iam_member.viewer, google_project_iam_member.editor]

}

data "google_project" "project" {
}

resource "google_project_iam_member" "viewer" {
  project = var.project_id
  role   = "roles/bigquery.metadataViewer"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "editor" {
  project = var.project_id
  role   = "roles/bigquery.dataEditor"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
