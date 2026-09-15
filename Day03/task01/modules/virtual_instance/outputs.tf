output "public_ip" {
  value = aws_instance.test.public_ip
}

output "id" {
  value = aws_instance.test.id
}