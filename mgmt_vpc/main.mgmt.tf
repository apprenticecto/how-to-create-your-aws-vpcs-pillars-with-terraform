# Terraform configuration to set-up a Management VCP with basic EC2 instance

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Building Managament VPC

module "mgmt_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.64"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true

  tags = var.vpc_tags
}

# allow incoming SSH traffic to the bastion host


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.mgmt_vpc.vpc_id

  ingress {
    description = "SSH incoming"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}

# adding ssh key for bastion host SSH access

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_host_key_aws"
  public_key = var.ssh_public_key
}

# Building EC2 instances

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.15"

  name           = var.ec2_instances_name
  instance_count = 1

  ami                    = var.ec2_instances_ami
  instance_type          = var.ec2_instances_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id              = module.mgmt_vpc.public_subnets[0]
  key_name = "bastion_host_key_aws"
  
  tags = {
    Terraform   = "true"
    Environment = "mgmt"
  }
}




