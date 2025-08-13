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

resource "aws_instance" "terraform_state" {
  ami = "ami-0169aa51f6faf20d5"
  instance_type = "t3.micro"
}

