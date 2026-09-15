output "web_public_ip" {
  value = module.web_app.web_server_ip
}

output "web_sg_id" {
  value = module.web_app.sg_id
}