resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-Security Group"
  description = "Open 22,443,80,465,8080,9000,9100,9090,3000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 465] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "react-sg"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-07d2649d67dbe8900"
  instance_type          = "t3.medium"
  key_name               = "project4"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data              = file("./jenkins.sh", {})

  tags = {
    Name = "react"
  }
  root_block_device {
    volume_size = 30
  }
}