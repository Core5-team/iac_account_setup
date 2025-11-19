resource "aws_subnet" "monitoring_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(var.common_tags, { Name = "private_${var.availability_zone}_monitoring_${var.env}" })
}

resource "aws_route_table" "monitoring_private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, { Name = "monitoring_private_rt_${var.env}" })
}

resource "aws_route" "monitoring_nat_route" {
  route_table_id         = aws_route_table.monitoring_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "monitoring_private_assoc" {
  subnet_id      = aws_subnet.monitoring_subnet.id
  route_table_id = aws_route_table.monitoring_private_rt.id
}

resource "aws_security_group" "monitoring_sg" {
  name   = "monitoring_sg_${var.env}"
  vpc_id = var.vpc_id

  description = "SG for central monitoring (Prometheus, Grafana, Loki)"

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = var.allowed_cidrs
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 9091
    to_port     = 9091
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 1514
    to_port     = 1514
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "monitoring_sg_${var.env}" })
}

resource "aws_ebs_volume" "monitoring_volume" {
  availability_zone = var.availability_zone
  size              = 8
  type              = "gp3"

  tags = merge(var.common_tags, { Name = "monitoring_volume_${var.env}" })
}

resource "aws_instance" "monitoring" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.monitoring_subnet.id
  vpc_security_group_ids      = [aws_security_group.monitoring_sg.id]
  key_name                    = var.key_pair
  iam_instance_profile        = var.iam_instance_profile
  user_data_replace_on_change = true

  tags = merge(var.common_tags, { Name = "monitoring_instance_${var.env}" })
}

resource "aws_volume_attachment" "monitoring_volume_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.monitoring_volume.id
  instance_id = aws_instance.monitoring.id
}

