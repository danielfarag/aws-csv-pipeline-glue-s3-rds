variable "bucket" {
  type = object({
    id = string
    arn = string
  })
}


variable "slack_webhook_url" {
  type = string
}

variable "region" {
  type = string
}


variable "crawler_name" {
  type = string
}

variable "job_name" {
  type = string
}

