# Input variable definitions

variable "azs" {
  description = "availability zones" 
  type = list
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "ec2_ami_bastion" {
  description = "aws ami id"
  type = string
  default = "ami-00f1068284b9eca92"
}

variable "ec2_type_bastion" {
  description = "ec2 instance type for bastion instances"
  type = string 
  default = "t2.micro"
}

variable "key_pair" {
  description = "ec2 key pair"
  type = string
}

variable "subnets_bastion" {
    description = "subnet ids for bastion instances"
    type = list(string)
}

variable "security_group_public" {
    description = "security group for bastion instances"
    type = string
}

variable "bastion_ssh_port" {
    description = "port number for bastion instances"
    type = number
    default = 22
}

variable "internal_cidrs" {
  description = "allowed cidrs to connect"
  type = list(string)
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
