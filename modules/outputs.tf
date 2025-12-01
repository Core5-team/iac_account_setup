output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.internet_gateway_id
}

output "key_pair_name" {
  value = aws_key_pair.jenkins-key-pair.key_name
}