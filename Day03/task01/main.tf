module "dev" {
  source = "./modules/virtual_instance"
  environment_tag = "dev"
  instance_type = "t3.micro"
}

module "prod" {
  source = "./modules/virtual_instance"
  environment_tag = "prod"
  instance_type = "t3.small"
}