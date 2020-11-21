output "mgmt_dev_vpcs_peering_id" {
  description = "ID of the VPC peering between mgmt and dev vpcs"
  value       = aws_vpc_peering_connection.mgmt_vpc.id
}


