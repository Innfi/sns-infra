# Terraform configuration

provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_file = var.provider_cred_path
    profile = var.profile
}

#module "vpc" {
#    source = "./modules/vpc"
#
#    azs = var.vpc_azs
#    name = var.vpc_name
#    cidr = var.vpc_cidr
#    subnet_public = var.vpc_public_subnets
#    subnet_private = var.vpc_private_subnets
#    key_pair = var.key_pair
#    port_http = var.port_http
#    port_was = var.port_was
#    internal_cidrs = var.internal_cidrs
#
#    tags = var.vpc_tags
#}
#
#module "mongo-instance" {
#    source = "./modules/mongo-instance"
#
#    azs = var.vpc_azs
#    name = var.vpc_name 
#    vpc_id = module.vpc.vpc_id
#    subnets_db = module.vpc.subnet_id_private
#    security_group_db = module.vpc.sg_id_private
#    key_pair = var.key_pair
#
#    tags = var.vpc_tags
#}

#module "frontend" {
    #source = "./modules/frontend" 

    #azs = var.vpc_azs 
    #name = var.vpc_name 
    #subnets_public = module.vpc.subnet_id_public
    #security_group_public = module.vpc.sg_id_public
    #key_pair = var.key_pair

    #tags = var.vpc_tags
#}

#module "backend" {
#    source = "./modules/backend"
#
#    azs = var.vpc_azs
#    name = var.vpc_name 
#    subnets_private = module.vpc.subnet_id_private
#    security_group_private = module.vpc.sg_id_private
#    key_pair = var.key_pair
#
#    tags = var.vpc_tags
#}

#module "bastion" {
#    source = "./modules/bastion"
#
#    azs = var.vpc_azs
#    name = var.vpc_name 
#    vpc_id = module.vpc.vpc_id
#    subnets_bastion = module.vpc.subnet_id_public 
#    security_group_public = module.vpc.sg_id_public
#    security_group_private = module.vpc.sg_id_private
#    key_pair = var.key_pair
#    internal_cidrs = var.internal_cidrs
#
#    tags = var.vpc_tags
#}

#data "template_file" "ansible_inventory" {
#    template = "${file(var.ansible_inven_template)}"
#    depends_on = [
#        module.mongo-instance,
#        module.bastion
#    ]
#
#    vars = {
#        mongodb_ips = "${join("\n", module.mongo-instance.mongodb_private_ips)}"
#        bastion_dns = "${join("\n", module.bastion.bastion_public_dns)}"
#    }
#}

#resource "null_resource" "inventories" {
#    triggers = {
#        template_rendered = "${data.template_file.ansible_inventory.rendered}"
#    } 
#
#    provisioner "local-exec" {
#        command = "echo '${data.template_file.ansible_inventory.rendered}' > ansible-playbooks/hosts"
#        interpreter = ["sh", "-c"]
#    }
#}

module "codepipeline-frontend" {
    source = "./modules/codepipeline-frontend"

    name = var.vpc_name 
    tags = var.vpc_tags
}
