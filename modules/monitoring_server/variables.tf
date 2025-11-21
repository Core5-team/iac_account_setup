variable "env" {
  type        = string
  description = "Environment (dev/stage/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
}

variable "ami" {
  type        = string
  description = "AMI ID for monitoring instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "key_pair" {
  type        = string
  description = "SSH key pair name"
  default     = null
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR for monitoring private subnet"
  default     = "10.0.8.0/24"
}

variable "nat_gateway_id" {
  type        = string
  description = "NAT gateway id for private route"
  default     = null
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "CIDRs or security group ids allowed to access monitoring services (can include SG ids)"
  default     = ["0.0.0.0/0"]
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for SSM (ssm-enabled). Provide ARN or name as used in your setup"
  default     = null
}
