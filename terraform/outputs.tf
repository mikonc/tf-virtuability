# OUTPUTS

output "vpc_id" {
  description = "The ID of the VPC."
  value       = try(module.vpc.vpc_id, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = try(module.vpc.vpc_cidr_block, "")
}

output "private_subnets" {
  description = "List of IDs of private subnets."
  value       = try(module.vpc.private_subnets, [])
}

output "private_subnets_cidr" {
  description = "List of CIDR blocks of private subnets."
  value       = try(module.vpc.private_subnets_cidr_blocks, [])
}

output "public_subnets" {
  description = "List of IDs of public subnets."
  value       = try(module.vpc.public_subnets, [])
}

output "public_subnets_cidr" {
  description = "List of CIDR blocks of public subnets."
  value       = try(module.vpc.public_subnets_cidr_blocks, [])
}

output "azs" {
  description = "A list of availability zones."
  value       = try(module.vpc.azs, [])
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs."
  value       = try(module.vpc.natgw_ids, [])
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway."
  value       = try(module.vpc.nat_public_ips, [])
}

output "igw_id" {
  description = "The ID of the Internet Gateway."
  value       = try(module.vpc.igw_id, "")
}

output "ec2_id" {
  description = "AMI ID that was used to create the instance."
  value       = try(module.ec2.*.id, "")
}

output "ec2_ami" {
  description = "AMI ID that was used to create the instance."
  value       = try(module.ec2.*.ami, "")
}
