
output "consul_server_private_ip" {
  value = aws_instance.consul_server.private_ip
}