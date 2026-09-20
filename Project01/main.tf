resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "tf_project01_main"
  }
}

resource "aws_subnet" "main1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public1
  availability_zone       = var.availability_zone1
  map_public_ip_on_launch = true
  tags = {
    Name = "tf_project01_main"
  }
}

resource "aws_subnet" "main2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public2
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true


  tags = {
    Name = "tf_project01_main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf_project01_main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "tf_project01_public_rt"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.main1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_project01_web-server-sg"
  }
}

resource "aws_instance" "web1" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("userdata.sh")
  tags = {
    Name = "tf_project01_web-server-1"
  }
}

resource "aws_instance" "web2" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main2.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("userdata1.sh")

  tags = {
    Name = "tf_project01_web-server-2"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-kevin-now-okay"

  tags = {
    Name        = "tf_project01_my_bucket"
    Environment = "Dev"
  }
}

resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.web_sg.id]
  subnets         = [aws_subnet.main1.id, aws_subnet.main2.id]

  tags = {
    Name = "tf_project01_web"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}

