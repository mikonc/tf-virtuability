# COMMON VARIABLES

variable "target_region" {
  description = "Target AWS region name."
  sensitive   = true
  type        = string
  default     = null
}

variable "project" {
  description = "Project name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

# NETWORK STACK VARIABLES

variable "network_cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = null

  validation {
    condition     = var.network_cidr == null ? true : can(cidrsubnet(var.network_cidr, 0, 0))
    error_message = "Must be a valid CIDR notation, e.g. 10.0.0.0/24."
  }
}

variable "network_azs" {
  description = "A list of availability zones names or IDs in the target region."
  type        = list(string)
  default     = []
}

variable "network_public_subnets" {
  description = "A list of public subnets CIDR bloks inside the VPC."
  type        = list(string)
  default     = []
}

variable "network_private_subnets" {
  description = "A list of private subnets CIDR bloks inside the VPC."
  type        = list(string)
  default     = []
}

variable "network_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks."
  type        = bool
  default     = false
}

variable "network_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks."
  type        = bool
  default     = false
}

variable "network_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires the number of `network_public_subnets` created to be greater than or equal to the number of availability zones."
  type        = bool
  default     = false
}

variable "network_create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}

variable "network_map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch."
  type        = bool
  default     = false
}

variable "network_enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC."
  type        = bool
  default     = true
}

variable "network_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

# EC2 STACK VARIABLES
variable "ami" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = null
  validation {
    condition = contains([
      "t2.micro",
      "t2.medium",
      "t2.large"
    ], var.instance_type)

    error_message = "Instance type should be one of the following: t2.micro, t2.medium, t2.large"
  }
}

variable "root_block_device" {
  type = list(any)
  default = [{
    encrypted   = true
    volume_type = "gp3"
    throughput  = 200
    volume_size = 100
  }]
}

variable "create_key_pair" {
  description = "Whether to create key-pair for EC2 instance."
  type        = bool
  default     = true
}

variable "key_pair_name" {
  description = "AWS EC2 key pair name (in case of using already existing key pair)."
  type        = string
  default     = null
}

variable "number_of_instances" {
  description = "Number of EC2 instances to deploy."
  type        = number
  default     = 2
}

variable "user_data_script" {
  description = "Script to run on instance startup."
  type        = string
}
