
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

variable "availability_zone" {
  type        = string
  description = "Availability zone"
  default     = "eu-central-1a"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for instances"
  default     = "ami-0a5b0d219e493191b"
}

variable "birdwatching_dns_name" {
  type        = string
  description = "DNS name for birdwatching"
  default     = "birdwatching.pp.ua"
}

variable "jenkins_ami_id" {
  type        = string
  description = "AMI ID for Jenkins EC2 instance"
  default     = "ami-0051c13afc17b19d8"
}

variable "birdwatching_ami_id" {
  type        = string
  description = "AMI ID for birdwatching instances"
  default     = "ami-0a5b0d219e493191b"
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


variable "enable_iam_ssm" {
  type        = bool
  description = "Deploy IAM for SSM module"
  default     = false
}

variable "enable_lb" {
  type        = bool
  description = "Deploy loadbalancer module"
  default     = false
}

variable "enable_web" {
  type        = bool
  description = "Deploy web servers module"
  default     = false
}

variable "enable_db" {
  type        = bool
  description = "Deploy database module"
  default     = false
}

variable "role_arn" {
  type    = string
  default = null
}

variable "cluster_availability_zone_1" {
  description = "One of availability zones where our nodes will be created"
  type        = string
}

variable "cluster_availability_zone_2" {
  description = "One of availability zones where our nodes will be created"
  type        = string
}


variable "private_subnet_cidr_block_1" {
  description = "Subnet for our nodes"
  type        = string
}

variable "private_subnet_cidr_block_2" {
  description = "Subnet for our nodes"
  type        = string
}

variable "public_subnet_cidr_block_1" {
  description = "Subnet for nat to let for our node connect to the internet"
  type        = string
}


variable "public_subnet_cidr_block_2" {
  description = "Subnet for ELB which will be later connected to ingress controller"
  type        = string
}


variable "min_size" {
  description = "Minimum number of nodes to have in the EKS cluster"
  type        = number
}
variable "max_size" {
  description = "Maximum number of nodes to have in the EKS cluster"
  type        = number
}

variable "desired_size" {
  description = "Desired number of nodes to have in the EKS cluster"
  type        = number
}


variable "eks_cluster_name" {
  description = "The name to use for the EKS cluster"
  type        = string
}

variable "environment_name" {
  description = "The name of environment where the EKS cluster will be created"
  type        = string
}

variable "eks_cluster_k8s_version" {
  description = "The kubernetes version that will be used for our cluster"
  type        = string
}


variable "node_instance_types" {
  description = "The types of EC2 instances to run in the node group"
  type        = list(string)
}

variable "vpc_id" {
  description = "The id of vpc where our application will be deployed"
  type        = string
}

variable "public_route_table_id" {
  description = "The id of the public route table where our nat and elb will be deployed"
  type        = string
}

variable "env" {
  type        = string
  description = "Environment to deploy resources"
  default     = "stage"
}
