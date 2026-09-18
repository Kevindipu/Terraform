provider "aws" {
  region = "eu-north-1"
}

# Security Group allowing SSH
resource "aws_security_group" "main" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false
    },
    {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      security_groups  = []
      prefix_list_ids  = []
      self             = false
      description      = "Allow all outbound traffic"
    }
  ]
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = "ami-0aba19e56f3eaec05" # Valid Amazon Linux 2 AMI for ap-south-1 (Mumbai)
  instance_type          = "t3.micro"
  key_name               = "devops-project"
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name        = "web-server"
    Environment = "dev"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("F:\\AWS\\devops-project.pem")
    host        = self.public_ip
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3 python3-pip nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}