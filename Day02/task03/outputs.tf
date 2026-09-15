output "type" {
  value = aws_instance.example.instance_type
}

output "name" {
  value = aws_instance.example.tags["name"]
}