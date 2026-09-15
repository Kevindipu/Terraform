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
  ami           = "ami-0aba19e56f3eaec05"
  instance_type = var.is_production ? "t3.medium" : "t3.micro"
  tags = {
    name = var.is_production ? "prod-server" : "dev-server"
  }
}
