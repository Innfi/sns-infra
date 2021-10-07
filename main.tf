# Terraform configuration

provider "aws" {
    region = "ap-northeast-2"
    shared_credentials_file = var.provider_cred_path
    profile = var.profile
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
#   source = "./modules/frontend" 
#
#   azs = var.vpc_azs 
#   name = var.vpc_name 
#   vpc_id = module.vpc.vpc_id
#   subnets_public = module.vpc.subnet_id_public
#   security_group_public = module.vpc.sg_id_public
#   key_pair = var.key_pair
#
#   tags = var.vpc_tags
#   rolename = var.rolename_frontend
#   general_instance_profile_name = module.vpc.general_instance_profile_name
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
#    #security_group_private = module.vpc.sg_id_private
#    key_pair = var.key_pair
#    internal_cidrs = var.internal_cidrs
#    ec2_ami_bastion = "ami-080d388232afa008d"
#
#    tags = var.vpc_tags
#}
#
#data "template_file" "ansible_inventory" {
#    template = file(var.ansible_inven_template)
#    depends_on = [
#        module.bastion,
#        module.frontend
#        #module.mongo-instance,
#    ]
#
#    vars = {
#        bastion_dns = join("\n", module.bastion.bastion_public_dns)
#        frontend_ips = join("\n", module.frontend.frontend_private_ips)
#        #mongodb_ips = "${join("\n", module.mongo-instance.mongodb_private_ips)}"
#    }
#}
#
#resource "null_resource" "inventories" {
#    triggers = {
#        template_rendered = data.template_file.ansible_inventory.rendered
#    } 
#
#    provisioner "local-exec" {
#        command = "echo '${data.template_file.ansible_inventory.rendered}' > ansible-playbooks/hosts"
#        interpreter = ["sh", "-c"]
#    }
#}

module "cicd-baseline" {
    source = "./modules/cicd-baseline" 

    name = var.vpc_name 
    tags = var.vpc_tags
}

module "codepipeline-frontend" {
    source = "./modules/codepipeline-frontend"

    rolename = var.rolename_frontend
    s3_sns_bucket = module.cicd-baseline.s3_sns_bucket
    s3_sns_id = module.cicd-baseline.s3_sns_id
    codepipeline_role_arn = module.cicd-baseline.codepipeline_role_arn
    codestarconnection_arn = module.cicd-baseline.codestarconnection_arn
    repo_id = var.repo_id_frontend
    name = var.vpc_name 
    tags = var.vpc_tags
}

module "codepipeline-backend" {
    source = "./modules/codepipeline-backend"

    rolename = var.rolename_backend
    s3_sns_bucket = module.cicd-baseline.s3_sns_bucket
    s3_sns_id = module.cicd-baseline.s3_sns_id
    codepipeline_role_arn = module.cicd-baseline.codepipeline_role_arn
    codestarconnection_arn = module.cicd-baseline.codestarconnection_arn
    repo_id = var.repo_id_backend
    name = var.vpc_name 
    tags = var.vpc_tags
}