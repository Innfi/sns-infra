# Output variable definitions 

output "bastion_public_dns" {
    description = "public dns addr of bastion instances"
    value = aws_instance.bastion.*.public_dns
}