# Terraform configuration

provider "aws" {
    version = "~> 2.0"
    region = "ap-northeast-2"
}

#module "vpc" {
    #source = "./modules/vpc"

    #azs = var.vpc_azs
    #name = var.vpc_name
    #cidr = var.vpc_cidr
    #subnet_public = var.vpc_public_subnets
    #key_pair = var.key_pair
    #port_http = var.port_http
    #port_was = var.port_was

    #tags = var.vpc_tags
#}

module "codedeploy-ec2" {
    source = "./modules/codedeploy-ec2"
    name = var.vpc_name


    tags = var.vpc_tags
}