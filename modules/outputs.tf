output "vpc_id" {
  value = var.enable_jenkins ? module.vpc[0].vpc_id : var.vpc_id
}

output "igw_id" {
  value = var.enable_jenkins ? module.vpc[0].internet_gateway_id : var.igw_id
}

output "key_pair_name" {
  value = var.enable_jenkins ? aws_key_pair.jenkins-key-pair[0].key_name : var.key_pair
}