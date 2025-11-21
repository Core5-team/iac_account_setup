output "monitoring_instance_id" {
  description = "Monitoring EC2 instance ID"
  value       = aws_instance.monitoring.id
}

output "monitoring_private_ip" {
  description = "Private IP of monitoring instance"
  value       = aws_instance.monitoring.private_ip
}

output "monitoring_subnet_id" {
  description = "Monitoring subnet ID"
  value       = aws_subnet.monitoring_subnet.id
}

output "monitoring_security_group_id" {
  description = "Security group used by monitoring instance"
  value       = aws_security_group.monitoring_sg.id
}

output "monitoring_volume_id" {
  description = "Attached monitoring EBS volume ID"
  value       = aws_ebs_volume.monitoring_volume.id
}

