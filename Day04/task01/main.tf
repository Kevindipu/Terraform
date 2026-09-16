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

resource "aws_instance" "name" {
  ami = "ami-03cc2fdb1443ab619"
  instance_type = "t3.micro"
  tags = { Name = "Exercise-1-Instance" }

}
