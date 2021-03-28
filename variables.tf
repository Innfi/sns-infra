# Input variable definitions 

variable "provider_cred_path" {
    description = "Shared credential path"
    type = string
    default = "~/.aws/credentials"
}

variable "profile" {
    description = "AWS profile"
    type = string
    default = "default"
}

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
        "ap-northeast-2a"
    ]
}

variable "vpc_public_subnets" {
    description = "Public Subnets"
    type = list(string) 
    default = [
        "10.0.1.0/24"
    ]
}

variable "vpc_private_subnets" {
    description = "Private Subnets" 
    type = list(string)
    default = [
        "10.0.3.0/24"
    ]
}

variable "key_pair" {
    description = "ec2 key pair"
    type = string
    default = "innfiskey-west1"
}

variable "port_http" {
  description = "port number for web(http) instances"
  type = number 
  default = 1330
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

variable "internal_cidrs" {
  description = "allowed cidrs to connect"
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "ansible_inven_template" {
    description = "ansible inventory template"
    type = string 
    default = "ansible-playbooks/mongodb/files/inventory.template"
}