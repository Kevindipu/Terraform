output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnets[0]
}

output "custom_sg_id" {
  value = aws_security_group.vpc_sg.id
}