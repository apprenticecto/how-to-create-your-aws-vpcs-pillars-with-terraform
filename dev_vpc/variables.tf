# Input variable definitions

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "dev_vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list
  default     = ["eu-central-1a"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "ec2_instances_name" {
  description = "ec2 instance type"
  type        = string
  default     = "private_ec2_dev_instance"
}

variable "ec2_instances_ami" {
  description = "ec2 instance ami"
  type        = string
  default     = "ami-0c960b947cbb2dd16"
}

variable "ec2_instances_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_public_key_private_subnet" {
  description = "private subnet instances ssh public key"
  type        = string
  default     = "paste your public key file content"
}




