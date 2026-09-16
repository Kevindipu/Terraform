terraform {
  backend "s3" {
    bucket         = "my-tf-test-bucket-kevin-work-now"
    key            = "dev/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
  }
}