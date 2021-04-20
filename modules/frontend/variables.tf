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

variable "ec2_ami_frontend" {
  description = "aws ami id"
  type = string
  default = "ami-00f1068284b9eca92"
}

variable "ec2_type_frontend" {
  description = "ec2 instance type for frontend instances"
  type = string 
  default = "t2.micro"
}

variable "key_pair" {
  description = "ec2 key pair"
  type = string
}

variable "subnets_public" {
    description = "subnet ids for frontend instances"
    type = list(string)
}

variable "security_group_public" {
    description = "public security group for frontend instances"
    type = string
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

variable "rolename" {
  description = "role name for frontend instances"
  type = string
}

variable "general_instance_profile_name" {
  description = "instance profile name for ec2 instances" 
  type = string
}
