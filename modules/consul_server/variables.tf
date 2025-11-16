
variable "ami_id" {
  type = string
  description = "ID of AMI"
}

variable "main_vpc_id" {
  type = string
  description = "ID of main vpc"
}

variable "sg_id" {
  type = string
  description = "ID of main security group"
}

variable "aws_region" {
  type = string
  description = "Name of aws region"
}



variable "private_subnet_id" {
  type = string
  description = "ID of consul server private subnet"
}