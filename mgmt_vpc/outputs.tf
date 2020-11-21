output "mgmt_vpc_public_subnet" {
  description = "IDs of the VPC's public subnet"
  value       = module.mgmt_vpc.public_subnets
}

output "mgmt_vpc_id" {
  description = "IDs of the VPC's private subnet"
  value       = module.mgmt_vpc.vpc_id
}

output "mgmt_vpc_public_subnets_cidr_block" {
  description = "IDs of the VPC's public subnet cidr block"
  value       = module.mgmt_vpc.public_subnets_cidr_blocks[0]
}

output "mgmt_vpc_public_route_table_id" {
  description = "IDs of the VPC's public subnet route table ID"
  value       = module.mgmt_vpc.public_route_table_ids[0]
}

output "mgmt_ec2_instance_public_ip" {
  description = "Public IP addresse of EC2 instance"
  value       = module.ec2_instances.public_ip
}
