resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-astro-kevin"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "eu_bucket" {
  provider = aws.eu_central
  bucket   = "my-app-storage-eu-central-1-demo"
}