

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "eu-central-1"
}

variable "available_zones_list" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "ami_id" {
  type        = string
  description = "AMI ID for instances"
  default     = "ami-0a5b0d219e493191b"
}

variable "jenkins_ami_id" {
  type        = string
  description = "AMI ID for Jenkins EC2 instance"
  default     = "ami-028a27dbcf0c459d5"
}


variable "enable_jenkins" {
  type        = bool
  description = "Deploy Jenkins module"
  default     = false
}

variable "enable_consul" {
  type        = bool
  description = "Deploy Consul server module"
  default     = false
}


variable "role_arn" {
  type    = string
  default = null
}
