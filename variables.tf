variable "environment" {
  type        = "string"
  description = "environment name (dev,test,prod,...)"
}

variable "author" {
  type        = "string"
  description = "author name"
  default     = "Thorsten Hans"
}

variable "custom_tags" {
  type        = "map"
  default     = {}
  description = "custom tags"
}
