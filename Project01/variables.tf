variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_public1" {
  type    = string
  default = "10.0.0.0/24"
}

variable "subnet_public2" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone1" {
  type    = string
  default = "eu-north-1a"
}

variable "availability_zone2" {
  type    = string
  default = "eu-north-1b"
}

variable "ami_id" {
  type = string
  default = "ami-0aba19e56f3eaec05"
}