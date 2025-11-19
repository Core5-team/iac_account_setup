resource "aws_subnet" "consul_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(var.common_tags, { Name = "private_${var.availability_zone}_consul_${var.env}" })
}

resource "aws_route_table" "consul_private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, { Name = "consul_private_rt_${var.env}" })
}

resource "aws_route" "consul_nat_route" {
  route_table_id         = aws_route_table.consul_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "consul_private_assoc" {
  subnet_id      = aws_subnet.consul_subnet.id
  route_table_id = aws_route_table.consul_private_rt.id
}

resource "aws_security_group" "consul_sg" {
  name   = "consul_sg_${var.env}"
  vpc_id = var.vpc_id

  description = "Security Group for Consul server (agent/server ports)"

  ingress {
    from_port   = 8300
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidrs]
  }

  ingress {
    from_port   = 8300
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = [var.allowed_cidrs]
  }

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidrs]
  }

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidrs]
  }

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = [var.allowed_cidrs]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidrs]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "consul_sg_${var.env}" })
}

resource "aws_ebs_volume" "consul_volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = var.volume_type

  tags = merge(var.common_tags, { Name = "consul_volume_${var.env}" })
}

resource "aws_instance" "consul_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.consul_subnet.id
  vpc_security_group_ids      = [aws_security_group.consul_sg.id]
  key_name                    = var.key_pair
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = false
  user_data_replace_on_change = true

  tags = merge(var.common_tags, { Name = "consul_server_${var.env}" })
}

resource "aws_volume_attachment" "consul_volume_attachment" {
  device_name  = var.volume_device_name
  volume_id    = aws_ebs_volume.consul_volume.id
  instance_id  = aws_instance.consul_server.id
  force_detach = true
}

resource "aws_route53_zone" "consul_internal" {
  name = var.route53_zone_name

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.aws_region
  }

  comment = "Private zone for consul services"
  tags    = var.common_tags
}

resource "aws_route53_record" "consul_record" {
  zone_id = aws_route53_zone.consul_internal.zone_id
  name    = var.consul_record_name
  type    = "A"
  ttl     = var.route53_ttl
  records = [aws_instance.consul_server.private_ip]
}

