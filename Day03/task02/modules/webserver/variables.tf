variable "allowed_ports" {
  type    = list(number)
  default = [80, 443]
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
