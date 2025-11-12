
resource "aws_instance" "consul_server" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = false

  tags = {
    Name = "Consul Server"
  }
}


resource "aws_route53_zone" "internal" {
  name = "internal"
  vpc {
    vpc_id = var.main_vpc_id
    vpc_region = var.aws_region
  }
}


resource "aws_route53_record" "consul_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "consul.internal"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.consul_server.private_ip]
}