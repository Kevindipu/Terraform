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

resource "aws_instance" "example" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    "Environment" = var.environment
  }
}