# LOCALS

locals {
  prefix = !strcontains(terraform.workspace, var.project) ? join("-", [terraform.workspace, var.project]) : terraform.workspace
  azs    = length(var.network_azs) > 0 ? var.network_azs : slice(data.aws_availability_zones.target.names, 0, 2)
}

# MODULES & RESOURCES

module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name                          = "${local.prefix}-vpc"
  cidr                          = var.network_cidr
  azs                           = local.azs
  public_subnets                = var.network_public_subnets
  private_subnets               = var.network_private_subnets
  enable_nat_gateway            = var.network_enable_nat_gateway
  single_nat_gateway            = var.network_single_nat_gateway
  create_igw                    = var.network_create_igw
  map_public_ip_on_launch       = var.network_map_public_ip_on_launch
  private_dedicated_network_acl = true

  private_outbound_acl_rules = concat([for v in var.network_private_subnets : {
    rule_number = index(var.network_private_subnets, v) + 100
    rule_action = "deny"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_block  = v
    }
    ], [
    {
      rule_number = 200
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    }
  ])
  enable_dns_support   = var.network_enable_dns_support
  enable_dns_hostnames = var.network_enable_dns_hostnames
  tags                 = var.tags
}

module "ec2" {

  source = "registry.terraform.io/terraform-aws-modules/ec2-instance/aws"
  count  = var.number_of_instances

  ami                    = var.ami
  instance_type          = var.instance_type
  availability_zone      = element(module.vpc.azs, count.index)
  subnet_id              = element(module.vpc.private_subnets, count.index)
  vpc_security_group_ids = [module.security_group.security_group_id]
  user_data_base64       = base64encode(var.user_data_script)

  key_name = var.create_key_pair ? aws_key_pair.this[0].id : var.key_pair_name != null ? var.key_pair_name : null

  enable_volume_tags          = false
  root_block_device           = var.root_block_device
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_name               = "ec2-ssm-role"

  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 10
    instance_metadata_tags      = "enabled"
  }

  tags = merge(var.tags, { "Name" = "${local.prefix}-ec2" })
}

################################################################################
# Supporting Resources
################################################################################
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.prefix}-ec2-sg"
  description = "Security group for usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]
  ingress_with_self = [
    {
      rule = "all-all"
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 88
      to_port     = 88
      protocol    = "tcp"
      cidr_blocks = var.network_cidr
    },
    {
      from_port   = 88
      to_port     = 88
      protocol    = "udp"
      cidr_blocks = var.network_cidr
  }]

  tags = var.tags
}

resource "random_string" "this" {
  count   = var.create_key_pair ? 1 : 0
  length  = 5
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "this" {
  count = var.create_key_pair ? 1 : 0
  name  = "${local.prefix}/ec2/key-pair-${random_string.this[0].result}"
  tags  = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = var.create_key_pair ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = trimspace(tls_private_key.this[0].private_key_pem)
}

resource "tls_private_key" "this" {
  count     = var.create_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = local.prefix
  public_key = trimspace(tls_private_key.this[0].public_key_openssh)
  tags       = var.tags
}
