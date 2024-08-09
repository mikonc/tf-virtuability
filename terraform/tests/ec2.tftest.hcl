variables {
  target_region = "eu-west-1"
  project       = "unit-testing"

  tags = {
    "Provisioner" = "Terraform"
    "Repository"  = "https://github.com/mikonc/tf-virtuability"
    "Environment" = "unit-testing"
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

run "ec2_ami_correct" {
  command = plan

  assert {
    condition     = module.ec2[0].ami == var.ami
    error_message = "EC2 AMI ID is different than expected!"
  }
}

run "ec2_instance_type_wrong" {
  command = plan

  variables {
    instance_type = "t2.xlarge"
  }

  expect_failures = [
    var.instance_type,
  ]
}

run "ec2_name_correct" {
  command = plan

  assert {
    condition     = module.ec2[0].tags_all.Name == "${terraform.workspace}-${var.project}-ec2"
    error_message = "EC2 instance name is different than expected!"
  }
}
