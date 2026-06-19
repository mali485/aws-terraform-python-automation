resource "aws_key_pair" "deployer" {
  key_name   = "ali-devops-key"
  public_key = file("terra-key.pub")
}

resource "aws_default_vpc" "default" {
}

# 1. NAYA BLOCK: Latest Ubuntu 22.04 AMI khud dhoondhne ke liye
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu) owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_security_group" "allow_user_to_connect" {
  name        = "ali-security-group"
  description = "Allow user to connect"
  vpc_id      = aws_default_vpc.default.id
  
  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysecurity"
  }
}

resource "aws_instance" "testinstance" {
  # 2. Yahan hum variable ke bajaye automatically fetched AMI use kar rahe hain
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro" 
  key_name        = aws_key_pair.deployer.key_name
  
  subnet_id = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_user_to_connect.id]

  depends_on = [aws_security_group.allow_user_to_connect, aws_key_pair.deployer]

  tags = {
    Name = "Automate"
  }

  root_block_device {
    volume_size = 30 
    volume_type = "gp3"
  }
}
