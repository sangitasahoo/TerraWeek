variable "aws_region" {
  description = "AWS region for the state bucket."
  type        = string
  default     = "us-west-2"
}

variable "state_bucket_name" {
  description = "Globally-unique name for the S3 state bucket. CHANGE THIS."
  type        = string
  default     = "sangs-terrawk-state-bucket-changeme"
}
