output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id_main1" {
  value = aws_subnet.main1.id
}

output "subnet_id_main2" {
  value = aws_subnet.main2.id
}

output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name
}