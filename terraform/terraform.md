<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.61.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | registry.terraform.io/terraform-aws-modules/ec2-instance/aws | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | registry.terraform.io/terraform-aws-modules/vpc/aws | 5.8.1 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_secretsmanager_secret.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_availability_zones.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | EC2 STACK VARIABLES | `string` | `null` | no |
| <a name="input_create_key_pair"></a> [create\_key\_pair](#input\_create\_key\_pair) | Whether to create key-pair for EC2 instance. | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `null` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | AWS EC2 key pair name (in case of using already existing key pair). | `string` | `null` | no |
| <a name="input_network_azs"></a> [network\_azs](#input\_network\_azs) | A list of availability zones names or IDs in the target region. | `list(string)` | `[]` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | The IPv4 CIDR block for the VPC. | `string` | `null` | no |
| <a name="input_network_create_igw"></a> [network\_create\_igw](#input\_network\_create\_igw) | Controls if an Internet Gateway is created for public subnets and the related routes that connect them. | `bool` | `true` | no |
| <a name="input_network_enable_dns_hostnames"></a> [network\_enable\_dns\_hostnames](#input\_network\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the VPC. | `bool` | `true` | no |
| <a name="input_network_enable_dns_support"></a> [network\_enable\_dns\_support](#input\_network\_enable\_dns\_support) | Should be true to enable DNS support in the VPC. | `bool` | `true` | no |
| <a name="input_network_enable_nat_gateway"></a> [network\_enable\_nat\_gateway](#input\_network\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks. | `bool` | `false` | no |
| <a name="input_network_map_public_ip_on_launch"></a> [network\_map\_public\_ip\_on\_launch](#input\_network\_map\_public\_ip\_on\_launch) | Should be false if you do not want to auto-assign public IP on launch. | `bool` | `false` | no |
| <a name="input_network_one_nat_gateway_per_az"></a> [network\_one\_nat\_gateway\_per\_az](#input\_network\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Requires the number of `network_public_subnets` created to be greater than or equal to the number of availability zones. | `bool` | `false` | no |
| <a name="input_network_private_subnets"></a> [network\_private\_subnets](#input\_network\_private\_subnets) | A list of private subnets CIDR bloks inside the VPC. | `list(string)` | `[]` | no |
| <a name="input_network_public_subnets"></a> [network\_public\_subnets](#input\_network\_public\_subnets) | A list of public subnets CIDR bloks inside the VPC. | `list(string)` | `[]` | no |
| <a name="input_network_single_nat_gateway"></a> [network\_single\_nat\_gateway](#input\_network\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks. | `bool` | `false` | no |
| <a name="input_number_of_instances"></a> [number\_of\_instances](#input\_number\_of\_instances) | Number of EC2 instances to deploy. | `number` | `2` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name. | `string` | `null` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | n/a | `list(any)` | <pre>[<br>  {<br>    "encrypted": true,<br>    "throughput": 200,<br>    "volume_size": 100,<br>    "volume_type": "gp3"<br>  }<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_target_region"></a> [target\_region](#input\_target\_region) | Target AWS region name. | `string` | `null` | no |
| <a name="input_user_data_script"></a> [user\_data\_script](#input\_user\_data\_script) | Script to run on instance startup. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones. |
| <a name="output_ec2_ami"></a> [ec2\_ami](#output\_ec2\_ami) | AMI ID that was used to create the instance. |
| <a name="output_ec2_id"></a> [ec2\_id](#output\_ec2\_id) | AMI ID that was used to create the instance. |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The ID of the Internet Gateway. |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway. |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | List of NAT Gateway IDs. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets. |
| <a name="output_private_subnets_cidr"></a> [private\_subnets\_cidr](#output\_private\_subnets\_cidr) | List of CIDR blocks of private subnets. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets. |
| <a name="output_public_subnets_cidr"></a> [public\_subnets\_cidr](#output\_public\_subnets\_cidr) | List of CIDR blocks of public subnets. |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
<!-- END_TF_DOCS -->
