provider "aws" {
  region = "eu-north-1"
}

module "web_app" {
  source = "./modules/webserver"
  ami_id = "ami-03cc2fdb1443ab619"
  instance_type = "t3.micro" 
}