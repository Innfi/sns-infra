# Output variable definitions

output "bastion_public_dns" {
    description = "access point for bastion hosts"
    value = module.bastion.bastion_public_dns
}

output "frontend_public_dns" {
    description = "access point for frontend instances"
    value = module.frontend.frontend_public_dns
}

#output "mongodb_private_ips" {
#    description = "private ip for mongodb instances"
#    value = module.mongo-instance.mongodb_private_ips
#}