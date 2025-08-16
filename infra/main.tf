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

  // Regra de entrada
  ingress {
    from_port = 80 // Porta padrão do servidor
    to_port = 80 // Porta padrão do servidor
    protocol = "tcp" // Forma de comunicação com o servidor
    cidr_blocks = ["0.0.0.0/0"] // Restringe quantos IPs tem acesso a aplicação. Nesse caso, eu estou dizendo que qualquer pessoa pode acessar a porta 80, independente do seu IP
  }

  // Regra de entrada pro SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Regra de saida
  egress {
    from_port = 0 // Qualquer porta do 0.
    to_port = 65535 // Até a porta 65535.
    protocol = "tcp" // Forma de comunicação com o servidor
    cidr_blocks = ["0.0.0.0/0"] // Qualquer IP pode ser acessado na saida.
  }
}

resource "aws_key_pair" "minha_keypair" {
  key_name = "terraform-keypair" // Serve para nomear o par de chaves
  public_key = file("~/.ssh/id_ed25519.pub") // Serve para acessar a nossa posta home/bielico através do ~, depois chegar até o arquivo ssh
}

resource "aws_vpc" "minha_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "minha_vpc"
  }
}

resource "aws_instance" "meu_ec3" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t3.micro"
  user_data = file("user_data.sh")
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.securitygroup.id]
}
