
variable "available_zones_list" {
  type        = list(string)
  description = "List of availability zones in region"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}