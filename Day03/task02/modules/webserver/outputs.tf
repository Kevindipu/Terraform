output "sg_id" {
  value = aws_security_group.web_sg.id
}

output "web_server_ip" {
  value       = aws_instance.web.public_ip
}