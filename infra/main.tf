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

  // Regra de saida
  egress {
    from_port = 0 // Qualquer porta do 0.
    to_port = 65550 // Até a porta 65550.
    protocol = "tcp" // Forma de comunicação com o servidor
    cidr_blocks = ["0.0.0.0/0"] // Qualquer IP pode ser acessado na saida.
  }
}

resource "aws_instance" "EC3server" {
  ami = "ami-0169aa51f6faf20d5"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.securitygroup.id]
}

