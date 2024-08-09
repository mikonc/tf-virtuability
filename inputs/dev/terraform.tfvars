target_region  = "eu-west-1"
project = "dev"

tags = {
  "Provisioner" = "Terraform"
  "Repository"  = "https://github.com/mikonc/tf-virtuability"
  "Environment" = "dev"
}

# NETWORK STACK VARIABLES
network_cidr                                 = "10.100.221.0/24"
network_public_subnets                       = ["10.100.221.0/26", "10.100.221.64/26"]
network_private_subnets                      = ["10.100.221.128/26", "10.100.221.192/26"]
network_create_igw                           = false
network_enable_nat_gateway                   = false
network_single_nat_gateway                   = false
network_enable_dns_support                   = true
network_enable_dns_hostnames                 = true

# EC2 STACK VARIABLES
ami              = "ami-0a2202cf4c36161a1"
instance_type    = "t2.micro"
number_of_instances = 2
create_key_pair = true
user_data_script = <<-EOT
  #!/bin/bash
  yum update -y
  EOT
