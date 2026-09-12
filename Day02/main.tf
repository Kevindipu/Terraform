# Write HCL code in Terraform to create a customized AWS virtual network from scratch, host a public EC2 instance inside it, configure explicit route tables, and ensure external connectivity via an Internet Gateway.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

# Create a VPC
resource "aws_vpc" "vpc_example" {
  cidr_block = var.vpc_cidr_block
}

#create a public subnet
resource "aws_subnet" "subnet_example" {
  vpc_id                  = aws_vpc.vpc_example.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "gateway_example" {
  vpc_id = aws_vpc.vpc_example.id

}

# Create a Custom Route Table
resource "aws_route_table" "route_table_example" {
  vpc_id = aws_vpc.vpc_example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_example.id
  }

}

# Associate Route Table with Subnet
resource "aws_route_table_association" "route_table_association_example" {
  subnet_id      = aws_subnet.subnet_example.id
  route_table_id = aws_route_table.route_table_example.id
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc_example.id

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = true
  subnet_id     = aws_subnet.subnet_example.id

  vpc_security_group_ids = [aws_security_group.allow_tls.id]

}