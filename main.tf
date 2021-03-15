# Terraform configuration

provider "aws" {
    version = "~> 2.0"
    region = "ap-northeast-2"
}

module "vpc" {
    source = "./modules/vpc"

    azs = var.vpc_azs
    name = var.vpc_name
    cidr = var.vpc_cidr
    subnet_public = var.vpc_public_subnets
    subnet_private = var.vpc_private_subnets
    key_pair = var.key_pair
    port_http = var.port_http
    port_was = var.port_was
    internal_cidrs = var.internal_cidrs

    tags = var.vpc_tags
}

module "mongo-instance" {
    source =  "./modules/mongo-instance"

    azs = var.vpc_azs
    name = var.vpc_name 
    vpc_id = module.vpc.vpc_id
    subnets_db = module.vpc.subnet_id_private
    security_group_db = module.vpc.sg_id_private
    key_pair = var.key_pair

    tags = var.vpc_tags
}

module "bastion" {
    source = "./modules/bastion"

    azs = var.vpc_azs
    name = var.vpc_name 
    vpc_id = module.vpc.vpc_id
    subnets_bastion = module.vpc.subnet_id_public 
    security_group_public = module.vpc.sg_id_public
    security_group_private = module.vpc.sg_id_private
    key_pair = var.key_pair
    internal_cidrs = var.internal_cidrs

    tags = var.vpc_tags
}

#module "codedeploy-ec2" {
#    source = "./modules/codedeploy-ec2"
#    name = var.vpc_name
#
#
#    tags = var.vpc_tags
#}