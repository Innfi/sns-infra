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
| ec2\_ami\_frontend | aws ami id | `string` | `"ami-00f1068284b9eca92"` | no |
| ec2\_type\_frontend | ec2 instance type for frontend instances | `string` | `"t2.micro"` | no |
| key\_pair | ec2 key pair | `string` | n/a | yes |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| security\_group\_public | public security group for frontend instances | `string` | n/a | yes |
| subnets\_public | subnet ids for frontend instances | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc\_tags | Additional tags for the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| frontend\_public\_dns | public dns for frontend instances |

