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

data "aws_region" "current" {}

resource "aws_s3_bucket" "example" {
  bucket = var.aws_s3_bucket

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  provisioner "local-exec" {
    command = "echo 'S3 bucket ${self.id} has been created at ${timestamp()} in AWS region ${data.aws_region.current.region}' >> deploy_audit.log"
  }

  provisioner "local-exec" {
    command    = "exit 1" # Intentional failure
    on_failure = continue
  }

}

resource "local_file" "app_config" {
  filename = "${path.module}/config.json"
  content = jsonencode({
    app = {
      name        = "my-application"
      environment = var.APP_ENV
      port = var.PORT
    }
  })
}


