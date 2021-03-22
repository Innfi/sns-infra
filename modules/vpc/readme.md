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
| cidr | vpc cidr | `string` | n/a | yes |
| ec2\_ami\_web | aws ami id | `string` | `"ami-08f35ff5d5c07e955"` | no |
| ec2\_type\_web | ec2 instance type for web instances | `string` | `"t2.micro"` | no |
| internal\_cidrs | allowed cidrs to connect | `list(string)` | n/a | yes |
| key\_pair | ec2 key pair | `string` | n/a | yes |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| port\_db | port number for rdb | `number` | `3306` | no |
| port\_http | port number for web(http) instances | `number` | `1330` | no |
| port\_https | port number for web(https) instances | `number` | `1331` | no |
| port\_ssh | port number for ssh | `number` | `22` | no |
| port\_was | port number for was instances | `number` | `3000` | no |
| subnet\_private | private subnet cidrs | `list` | n/a | yes |
| subnet\_public | public subnet cidrs | `list` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_tags | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sg\_id\_private | private security group id |
| sg\_id\_public | public security group id |
| subnet\_id\_private | private subnet ids |
| subnet\_id\_public | public subnet ids |
| vpc\_id | vpc id |

