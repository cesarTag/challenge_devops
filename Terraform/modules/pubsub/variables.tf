variable "topic_name" {
  description = "The name of the Pub/Sub topic"
  type        = string
}

variable "subscription_name" {
  description = "The name of the Pub/Sub subscription"
  type        = string
}

variable "project_id" {
  description = "The name of the Pub/Sub subscription"
  type        = string
}
variable "subscription_labels" {
  type        = map(string)
  description = "A map of labels to assign to every Pub/Sub subscription."
  default     = {}
}
variable "ack" {
  description = "The name of the Pub/Sub subscription"
  type        = number
  default = 20
}
variable "message_retention" {
  type        = string
  description = "The minimum duration in seconds to retain a message after it is published to the topic."
  default     = null
}
