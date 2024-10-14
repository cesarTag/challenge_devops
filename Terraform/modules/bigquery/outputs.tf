output "bigquery_dataset_id" {
  description = "The ID of the created BigQuery dataset"
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "bigquery_table_id" {
  description = "The ID of the created BigQuery table"
  value       = google_bigquery_table.table.table_id
}

output "bigquery_table" {
  description = "The ID of the created BigQuery table"
  value       = google_bigquery_table.table
}