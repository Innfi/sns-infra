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

variable "cidr" {
  description = "vpc cidr"
  type        = string
}

variable "internal_cidrs" {
  description = "allowed cidrs to connect"
  type = list(string)
}

variable "subnet_public" {
  description = "public subnet cidrs"
  type = list
}

variable "subnet_private" {
  description = "private subnet cidrs"
  type = list
}

variable "key_pair" {
  description = "ec2 key pair"
  type = string
}

variable "port_http" {
  description = "port number for web(http) instances"
  type = number 
  default = 1330
}

variable "port_https" {
  description = "port number for web(https) instances"
  type = number 
  default = 1331
}

variable "port_was" {
  description = "port number for was instances" 
  type = number 
  default = 3000
}

variable "port_db" {
  description = "port number for rdb"
  type = number 
  default = 3306
}

variable "port_ssh" {
  description = "port number for ssh" 
  type = number 
  default = 22
}

variable "ec2_ami_web" {
  description = "aws ami id"
  type = string
  default = "ami-08f35ff5d5c07e955"
}

variable "ec2_type_web" {
  description = "ec2 instance type for web instances"
  type = string 
  default = "t2.micro"
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
