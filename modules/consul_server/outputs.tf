output "consul_server_id" {
  description = "Consul EC2 instance ID"
  value       = aws_instance.consul_server.id
}

output "consul_server_private_ip" {
  description = "Private IP of Consul server"
  value       = aws_instance.consul_server.private_ip
}

output "consul_server_subnet_id" {
  description = "Subnet id for Consul server"
  value       = aws_subnet.consul_subnet.id
}

output "consul_server_security_group_id" {
  description = "Security group used by Consul server"
  value       = aws_security_group.consul_sg.id
}

output "consul_server_volume_id" {
  description = "Attached EBS volume ID"
  value       = aws_ebs_volume.consul_volume.id
}

output "consul_route53_zone_id" {
  description = "Private Route53 zone id for consul"
  value       = aws_route53_zone.consul_internal.zone_id
}

