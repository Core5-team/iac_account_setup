
terraform {
  required_version = ">= 1.5.0"
  backend "s3" {}
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
  depends_on = [tls_private_key.sskeygen-execution]
  key_name   = "jenkins-public"
  public_key = tls_private_key.sskeygen-execution.public_key_openssh
  count      = var.create_vpc ? 1 : 0
}

module "vpc" {
  source               = "./vpc"
  available_zones_list = var.available_zones_list
  count                = var.create_vpc ? 1 : 0

}

locals {
  vpc_id_final   = var.create_vpc ? module.vpc[0].vpc_id : var.vpc_id
  igw_id_final   = var.create_vpc ? module.vpc[0].internet_gateway_id : var.igw_id
  key_pair_final = var.create_vpc ? aws_key_pair.jenkins-key-pair[0].key_name : var.key_pair
}


module "sg" {
  source      = "./security_group"
  main_vpc_id = local.vpc_id_final
}

module "iam_ssm" {
  source = "./iam_ssm"
  count  = var.enable_iam_ssm ? 1 : 0
}

module "consul_server" {
  source               = "./consul_server"
  env                  = var.env
  vpc_id               = local.vpc_id_final
  availability_zone    = var.availability_zone
  ami_id               = var.birdwatching_ami_id
  instance_type        = "t3.micro"
  key_pair             = local.key_pair_final
  private_subnet_cidr  = "10.0.9.0/24"
  nat_gateway_id       = var.nat_id 
  allowed_cidrs        = ["10.0.0.0/16"]
  iam_instance_profile = module.iam_ssm[0].ssm_instance_profile_name
  common_tags          = { env = var.env }
  count                = var.enable_consul ? 1 : 0
}

module "jenkins" {
  source            = "git::https://github.com/Core5-team/iac_core.git//modules/jenkins?ref=CORE5-14-change-tags-in-iac-core"
  region            = var.aws_region
  vpc_id            = local.vpc_id_final
  igw_id            = local.igw_id_final
  env               = "stage_01"
  ami               = var.jenkins_ami_id
  instance_type     = "c7i-flex.large"
  availability_zone = "us-east-1a"
  subnet_cidr       = "10.0.1.0/24"
  count             = var.enable_jenkins ? 1 : 0
}


module "lb" {
  source               = "git::https://github.com/Core5-team/iac_birdwatching.git//modules/lb?ref=CORE5-16-change-_-to-in-s3-bucket-name"
  vpc_id               = local.vpc_id_final
  igw_id               = local.igw_id_final
  public_rt_id       = var.public_rt_id
  availability_zone    = var.availability_zone
  common_tags          = { env = "stage" }
  env                  = var.env
  ami                  = var.birdwatching_ami_id
  instance_type        = "t3.micro"
  key_name             = local.key_pair_final
  dns_name             = var.birdwatching_dns_name
  public_subnet_cidr   = "10.0.3.0/24"
  iam_instance_profile = module.iam_ssm[0].ssm_instance_profile_name
  count                = var.enable_lb ? 1 : 0
}

module "web" {
  source      = "git::https://github.com/Core5-team/iac_birdwatching.git//modules/web?ref=CORE5-16-change-_-to-in-s3-bucket-name"
  vpc_id                  = local.vpc_id_final
  availability_zone       = var.availability_zone
  common_tags             = { env = "stage" }
  env                     = var.env
  ami                     = var.birdwatching_ami_id
  instance_type           = "t3.micro"
  key_name                = local.key_pair_final
  private_web_subnet_cidr = "10.0.4.0/24"
  nat_gateway_id       = var.nat_id 
  allowed_cidrs = [
    module.lb[0].security_group_id,
    module.consul_server[0].consul_server_security_group_id,
    module.sg.sg_id
  ]
  count = var.enable_web ? 1 : 0
}

module "db" {
  source      = "git::https://github.com/Core5-team/iac_birdwatching.git//modules/db?ref=CORE5-16-change-_-to-in-s3-bucket-name"
  vpc_id            = local.vpc_id_final
  availability_zone = var.availability_zone
  common_tags       = { env = "stage" }
  env               = var.env
  ami               = var.birdwatching_ami_id
  instance_type     = "t3.micro"
  key_pair          = local.key_pair_final
  db_subnet_cidr    = "10.0.5.0/24"
  nat_gateway_id       = var.nat_id 
  allowed_cidrs = [
    module.web[0].security_group_id,
    module.consul_server[0].consul_server_security_group_id,
    module.sg.sg_id
  ]
  iam_instance_profile = module.iam_ssm[0].ssm_instance_profile_name
  count                = var.enable_db ? 1 : 0
}

module "images_bucket" {
  source      = "git::https://github.com/Core5-team/iac_birdwatching.git//modules/s3_images?ref=CORE5-16-change-_-to-in-s3-bucket-name"
  env         = var.env
  project     = "birdwatching"
  common_tags = { env = var.env }
}

module "monitoring" {
  source              = "./monitoring_server"
  vpc_id              = local.vpc_id_final
  availability_zone   = var.availability_zone
  common_tags         = { env = var.env }
  env                 = var.env
  ami                 = var.birdwatching_ami_id
  instance_type       = "c7i-flex.large"
  key_pair            = local.key_pair_final
  private_subnet_cidr = "10.0.8.0/24"
  nat_gateway_id       = var.nat_id 
  allowed_cidrs = [
    module.lb[0].security_group_id,
    module.web[0].security_group_id,
    module.db[0].db_security_group_id,
    module.consul_server[0].consul_server_security_group_id,
    module.sg.sg_id,
  ]
  iam_instance_profile = module.iam_ssm[0].ssm_instance_profile_name
  count                = var.enable_monitoring ? 1 : 0
}

