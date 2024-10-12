resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  location   = var.region
}

resource "google_bigquery_table" "table" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = var.table_id

  schema = jsonencode([
    {
      name = "id"
      type = "STRING"
      mode = "REQUIRED"
    },
    {
      name = "value"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "timestamp"
      type = "TIMESTAMP"
      mode = "REQUIRED"
    }
  ])
}
