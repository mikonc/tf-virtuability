variables {
  target_region = "eu-west-1"
  project       = "unit-testing"

  tags = {
    "Provisioner" = "Terraform"
    "Repository"  = "https://github.com/mikonc/tf-virtuability"
  }

  # NETWORK STACK VARIABLES
  network_cidr                 = "10.100.221.0/24"
  network_public_subnets       = ["10.100.221.0/26", "10.100.221.64/26"]
  network_private_subnets      = ["10.100.221.128/26", "10.100.221.192/26"]
  network_create_igw           = false
  network_enable_nat_gateway   = false
  network_single_nat_gateway   = false
  network_enable_dns_support   = true
  network_enable_dns_hostnames = true

  # EC2 STACK VARIABLES
  ami                 = "ami-0a2202cf4c36161a1"
  instance_type       = "t2.micro"
  number_of_instances = 2
  user_data_script    = <<-EOT
  #!/bin/bash
  yum update -y
  EOT
}

run "vpc_cidr_block_correct" {
  command = plan

  assert {
    condition     = module.vpc.vpc_cidr_block == var.network_cidr
    error_message = "VPC CIDR Block is different than expected!"
  }
}

run "vpc_cidr_block_wrong" {
  command = plan

  variables {
    network_cidr = "10.0.0.0/"
  }

  expect_failures = [
    var.network_cidr,
  ]
}

run "vpc_dns_support_correct" {
  command = plan

  variables {
    network_enable_dns_support = true
  }

  assert {
    condition     = module.vpc.vpc_enable_dns_support == var.network_enable_dns_support
    error_message = "VPC DNS support is different than expected!"
  }
}

run "vpc_public_subnet_count_correct" {
  command = plan

  assert {
    condition     = length(module.vpc.public_subnets) == length(var.network_public_subnets)
    error_message = "VPC public subnets count is different than expected!"
  }
}
