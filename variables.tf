# Input variable definitions 

variable "vpc_name" {
    description = "Name of VPC"
    type = string 
    default = "SNSv1-VPC"
}

variable "vpc_cidr" {
    description = "VPC CIDR blocks"
    type = string 
    default = "10.0.0.0/16"
}

variable "vpc_azs" {
    description = "AZs"
    type = list 
    default =  [
        "ap-northeast-2a",
        "ap-northeast-2c"
    ]
}

variable "vpc_public_subnets" {
    description = "Public Subnets"
    type = list(string) 
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
}

variable "key_pair" {
    description = "ec2 key pair"
    type = string
    default = "InnfisKey"
}

variable "port_http" {
  description = "port number for web(http) instances"
  type = number 
  default = 80
}

variable "port_was" {
  description = "port number for was instances" 
  type = number 
  default = 3000
}

variable "vpc_tags" {
    description = "VPC tags"
    type = map(string)
    default = {
        Terraform = "true"
        Environment = "dev"
    }
}
