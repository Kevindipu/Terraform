provider "aws" {
  region = "eu-north-1" # Set your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0aba19e56f3eaec05" # Canonical, Ubuntu, 26.04, amd64 resolute image
  instance_type = "t3.micro"
}