

terraform {
  required_version = ">= 1.5.0"
}


provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = var.role_arn
    session_name = "jenkins-terraform"
  }
}

resource "tls_private_key" "sskeygen-execution" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "jenkins-key-pair" {
  depends_on = ["tls_private_key.sskeygen-execution"]
  key_name   = "jenkins-public"
  public_key = tls_private_key.sskeygen-execution.public_key_openssh
}

module "vpc" {
  source               = "./vpc"
  available_zones_list = var.available_zones_list
}


module "sg" {
  source      = "./security_group"
  main_vpc_id = module.vpc.vpc_id
}

module "iam_ssm" {
  source = "./modules/iam_ssm"
}

module "consul_server" {
  source            = "./consul_server"
  ami_id            = var.ami_id
  main_vpc_id       = module.vpc.vpc_id
  sg_id             = module.sg.sg_id
  aws_region        = var.aws_region
  private_subnet_id = module.vpc.private_subnet_ids[0]
  count             = var.enable_consul ? 1 : 0
}


module "jenkins" {
  source            = "git::https://github.com/The-A-Team-organization/iac_core.git//modules/jenkins?ref=TAT-86-Create-Stage-Infrastructure-Terraform-Jenkins-ECR-SonarQube-IAM-Cross-Account-Policies"
  region            = var.aws_region
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.vpc.internet_gateway_id
  env               = "stage"
  ami               = var.jenkins_ami_id
  instance_type     = "t3.medium"
  availability_zone = "eu-central-1a"
  subnet_cidr       = "10.0.1.0/24"
  count             = var.enable_jenkins ? 1 : 0
}

module "lb" {
  source = "git::https://github.com/The-A-Team-organization/iac_birdwatching.git//modules/lb?ref=TAT-93-Refactor-and-Extend-Terraform-Configuration-From-Module-1-for-Birdwatching-Application-Infrastructure"

  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.internet_gateway_id
  availability_zone    = "eu-central-1a"
  common_tags          = { env = "stage" }
  env                  = "stage"
  ami                  = "ami-0a5b0d219e493191b"
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.jenkins-key-pair.key_name
  dns_name             = "birdwatching.pp.ua"
  public_subnet_cidr   = "10.0.50.0/24"
  iam_instance_profile = module.iam_ssm.ssm_instance_profile_name
}

module "web" {
  source = "git::https://github.com/The-A-Team-organization/iac_birdwatching.git//modules/web?ref=TAT-93-Refactor-and-Extend-Terraform-Configuration-From-Module-1-for-Birdwatching-Application-Infrastructure"

  vpc_id                  = module.vpc.vpc_id
  availability_zone       = "eu-central-1a"
  common_tags             = { env = "stage" }
  env                     = "stage"
  ami                     = "ami-0a5b0d219e493191b"
  instance_type           = "t3.micro"
  key_name                = aws_key_pair.jenkins-key-pair.key_name
  private_web_subnet_cidr = "10.0.70.0/24"
  nat_gateway_id          = module.lb.nat_gateway_id
  allowed_cidrs           = [module.lb.security_group_id, module.jenkins.security_group_id, module.consul_server[0].sg_id]
}

module "db" {
  source = "git::https://github.com/The-A-Team-organization/iac_birdwatching.git//modules/db?ref=TAT-93-Refactor-and-Extend-Terraform-Configuration-From-Module-1-for-Birdwatching-Application-Infrastructure"

  vpc_id               = module.vpc.vpc_id
  availability_zone    = "eu-central-1a"
  common_tags          = { env = "stage" }
  env                  = "stage"
  ami                  = "ami-0a5b0d219e493191b"
  instance_type        = "t3.micro"
  key_pair             = aws_key_pair.jenkins-key-pair.key_name
  db_subnet_cidr       = "10.0.60.0/24"
  nat_gateway_id       = module.lb.nat_gateway_id
  allowed_cidrs        = [module.web.security_group_id, module.jenkins.security_group_id, module.consul_server[0].sg_id]
  iam_instance_profile = module.iam_ssm.ssm_instance_profile_name
}

# module "sonarqube" {
#   source = "url"
#   vpc_id = module.vpc.vpc_id
#   sg_id  = module.sg.sg_id
#   count  = var.enable_sonarqube ? 1 : 0
# }
