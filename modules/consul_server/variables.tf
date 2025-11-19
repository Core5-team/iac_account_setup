variable "env" {
  type        = string
  description = "Environment (dev/stage/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "aws_region" {
  type        = string
  description = "AWS region where the VPC exists"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for Consul instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_pair" {
  type        = string
  description = "SSH key pair name"
  default     = null
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR for consul private subnet"
  default     = "10.0.9.0/24"
}

variable "nat_gateway_id" {
  type        = string
  description = "NAT gateway id for private route"
  default     = null
}

variable "allowed_cidrs" {
  type        = string
  description = "CIDRs allowed to access consul service ports"
  default     = ["10.0.0.0/16"]
}

variable "volume_size" {
  type        = number
  description = "EBS volume size in GB"
  default     = 8
}

variable "volume_type" {
  type        = string
  description = "EBS volume type"
  default     = "gp3"
}

variable "volume_device_name" {
  type        = string
  description = "Device name to attach EBS (Linux)"
  default     = "/dev/sdh"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for SSM (optional)"
  default     = null
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}

variable "route53_zone_name" {
  type        = string
  description = "Private Route53 zone name"
  default     = "consul.internal"
}

variable "consul_record_name" {
  type        = string
  description = "A record name for the consul server inside private zone"
  default     = "consul.internal"
}

variable "route53_ttl" {
  type        = number
  description = "TTL for route53 record"
  default     = 300
}

