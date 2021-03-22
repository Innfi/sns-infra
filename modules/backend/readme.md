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
| ec2\_ami\_backend | aws ami id | `string` | `"ami-00f1068284b9eca92"` | no |
| ec2\_type\_backend | ec2 instance type for backend instances | `string` | `"t2.micro"` | no |
| key\_pair | ec2 key pair | `string` | n/a | yes |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| security\_group\_private | private security group for backend instances | `string` | n/a | yes |
| subnets\_private | subnet ids for backend instances | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_tags | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_private\_ips | private addr for backend instances |

