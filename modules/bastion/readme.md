## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azs | availability zones | `list` | n/a | yes |
| bastion\_ssh\_port | port number for bastion instances | `number` | `22` | no |
| ec2\_ami\_bastion | aws ami id | `string` | `"ami-00f1068284b9eca92"` | no |
| ec2\_type\_bastion | ec2 instance type for bastion instances | `string` | `"t2.micro"` | no |
| internal\_cidrs | allowed cidrs to connect | `list(string)` | n/a | yes |
| key\_pair | ec2 key pair | `string` | n/a | yes |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| security\_group\_private | private security group for bastion instances | `string` | n/a | yes |
| security\_group\_public | public security group for bastion instances | `string` | n/a | yes |
| subnets\_bastion | subnet ids for bastion instances | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_id | vpc id | `string` | n/a | yes |
| vpc\_tags | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion\_public\_dns | public dns of bastion instances |

