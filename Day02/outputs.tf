output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_example.id
}

output "subnet_id" {
  description = "The ID of the Public Subnet"
  value       = aws_subnet.subnet_example.id
}

output "ec2_public_ip" {
  description = "Public IP address of the launched EC2 instance"
  value       = module.ec2_instance.public_ip
}