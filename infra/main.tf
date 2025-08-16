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

resource "aws_security_group" "meu_sg" {
  name = "securitygroup"
  description = "Acesso total(nao use em producao"
  vpc_id = aws_vpc.minha_vpc.id

  tags = {
    Name = "meu_sg"
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
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

  resource "aws_internet_gateway" "meu_ig" {
    vpc_id = aws_vpc.minha_vpc.id

    tags = {
      Name = "meu_ig"
    }
  }

  resource "aws_route_table" "meu_rt" {
    vpc_id = aws_vpc.minha_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.meu_ig.id
    }

    tags = {
      Name = "meu_rt"
    }
  }

  resource "aws_route_table_association" "meu_rta" {
    route_table_id = aws_route_table.meu_rt.id
    subnet_id = aws_subnet.minha_subnet.id
  }

    resource "aws_key_pair" "minha_keypair" {
      key_name = "minha_keypair"
      public_key = file("~/.ssh/id_ed25519.pub")
    }

    resource "aws_instance" "meu_ec2" {
          ami           = "ami-0de716d6197524dd9"
          instance_type = "t3.micro"
          subnet_id = aws_subnet.minha_subnet.id
          associate_public_ip_address = true
          key_name = aws_key_pair.minha_keypair
          vpc_security_group_ids = [aws_security_group.meu_sg.id]
          user_data = file("user_data.sh")
    }
