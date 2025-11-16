
variable "available_zones_list" {
  type        = list(string)
  description = "List of availability zones in region"
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}