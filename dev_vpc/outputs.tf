output "dev_vpc_private_subnet" {
  description = "IDs of the VPC's private subnet"
  value       = module.dev_vpc.private_subnets
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.dev_vpc.vpc_id
}

output "dev_vpc_private_route_table_id" {
  description = "IDs of the VPC's public subnet route table ID"
  value       = module.dev_vpc.private_route_table_ids[0]
}

output "dev_vpc_public_subnets_cidr_block" {
  description = "IDs of the VPC's public subnet cidr block"
  value       = module.dev_vpc.public_subnets_cidr_blocks[0]
}

output "dev_vpc_private_subnets_cidr_block" {
  description = "IDs of the VPC's private subnet cidr block"
  value       = module.dev_vpc.private_subnets_cidr_blocks[0]
}

output "dev_ec2_instance_private_ip" {
  description = "Private IP addresse of EC2 instance"
  value       = module.ec2_instances.private_ip
}
