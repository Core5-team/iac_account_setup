## Account Setup — AWS Infrastructure Provisioning

This repository contains Terraform code used to bootstrap a full AWS environment, including networking, compute, Jenkins, service mesh components, monitoring, and IAM integrations.

The project supports two provisioning modes:

Mode A — Create a new VPC inside this environment

Mode B — Reuse an existing VPC provided via variables

The mode is selected using:

```
create_vpc = true/false
```

## Conditional VPC Creation

If create_vpc = true:

A new VPC is created using the vpc module

A new Internet Gateway is created

A new KeyPair is generated inside the module

If create_vpc = false:

The infrastructure reuses:

var.vpc_id

var.igw_id

var.key_pair

## Architecture Overview

The repository provisions:

VPC + subnets (optional)

Jenkins EC2 host (optional)

LB → Web → DB service chain

Consul service server

Monitoring server (Grafana, Prometheus)

SSM IAM roles for EC2 access

S3 Images bucket

Routing between modules is coordinated via locals:
