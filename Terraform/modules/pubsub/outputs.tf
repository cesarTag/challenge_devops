output "pubsub_topic_id" {
  description = "The ID of the created Pub/Sub topic"
  value       = google_pubsub_topic.topic.id
}

output "pubsub_subscription_id" {
  description = "The ID of the created Pub/Sub subscription"
  value       = google_pubsub_subscription.bigquery_subscription.id
}
