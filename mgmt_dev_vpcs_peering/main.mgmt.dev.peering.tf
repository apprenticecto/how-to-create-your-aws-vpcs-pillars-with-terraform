# Terraform configuration to peer mgmt and dev vpcs

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

# Accessing remote state from mgmt environment

data "terraform_remote_state" "mgmt_vpc" {
  backend = "local"

  config = {
    path = "../mgmt_vpc/terraform.tfstate"
  }
}


# Accessing remote state from develpment environment

data "terraform_remote_state" "dev_vpc" {
  backend = "local"

  config = {
    path = "../dev_vpc/terraform.tfstate"
  }
}


# Configuring VPC peering between mgmt and dev VPCs (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options and https://www.terraform.io/docs/providers/terraform/d/remote_state.html)

resource "aws_vpc_peering_connection" "mgmt_vpc" {
  vpc_id      = data.terraform_remote_state.mgmt_vpc.outputs.mgmt_vpc_id
  peer_vpc_id = data.terraform_remote_state.dev_vpc.outputs.vpc_id

  auto_accept = true
}

resource "aws_vpc_peering_connection_options" "mgmt_vpc" {
  vpc_peering_connection_id = aws_vpc_peering_connection.mgmt_vpc.id


  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_vpc_to_remote_classic_link = false
    allow_classic_link_to_remote_vpc = false
  }
}

# Add route to dev peered VPC

resource "aws_route" "mgmt_route_table_dev_peer" {
  route_table_id            = data.terraform_remote_state.mgmt_vpc.outputs.mgmt_vpc_public_route_table_id
  destination_cidr_block    = data.terraform_remote_state.dev_vpc.outputs.dev_vpc_private_subnets_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mgmt_vpc.id
}

# Add route to mgmt peered VPC

resource "aws_route" "dev_route_table_mgmt_peer" {
  route_table_id            = data.terraform_remote_state.dev_vpc.outputs.dev_vpc_private_route_table_id
  destination_cidr_block    = data.terraform_remote_state.mgmt_vpc.outputs.mgmt_vpc_public_subnets_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mgmt_vpc.id
}




