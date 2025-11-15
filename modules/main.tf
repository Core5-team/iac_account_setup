

terraform {
  required_version = ">= 1.5.0"
}


provider "aws" {
  region  = var.aws_region

   assume_role {
    role_arn     = var.role_arn
    session_name = "jenkins-terraform"
  }
}


module "vpc" {
  source = "./vpc"
  available_zones_list = var.available_zones_list
}


module "sg" {
  source = "./security_group"
  main_vpc_id = module.vpc.vpc_id
}


module "consul_server" {
  source = "./consul_server"
  ami_id = var.ami_id
  main_vpc_id = module.vpc.vpc_id
  sg_id = module.sg.sg_id
  aws_region = var.aws_region
  private_subnet_id = module.vpc.private_subnet_ids[0]
  count  = var.enable_consul ? 1 : 0
}


module "jenkins" {
  source = "git::https://github.com/The-A-Team-organization/iac_core.git//modules/jenkins?ref=TAT-86-Create-Stage-Infrastructure-Terraform-Jenkins-ECR-SonarQube-IAM-Cross-Account-Policies"
  region = var.aws_region
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.internet_gateway_id
  env = "stage"
  ami = var.jenkins_ami_id
  instance_type = "t3.medium"
  availability_zone = "eu-central-1a"
  subnet_cidr = "10.0.1.0/24"
  # user_data = file("${path.module}/install_jenkins.sh")
  count  = var.enable_jenkins ? 1 : 0

}


# module "sonarqube" {
#   source = "url"
#   vpc_id = module.vpc.vpc_id
#   sg_id  = module.sg.sg_id
#   count  = var.enable_sonarqube ? 1 : 0
# }
