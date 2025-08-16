terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "securitygroup" {
  name = "securitygroup"
  description = "Permitir acesso HTTP e acesso a Internet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "minha_keypair" {
  key_name = "terraform-keypair"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_vpc" "minha_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "minha_vpc"
  }
}

resource "aws_subnet" "minha_subnet" {
  vpc_id = aws_vpc.minha_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "minha_subnet"
  }
}

resource "aws_instance" "meu_ec3" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t3.micro"
  user_data = file("user_data.sh")
  key_name = aws_key_pair.minha_keypair
  vpc_security_group_ids = [aws_security_group.securitygroup.id]
}
