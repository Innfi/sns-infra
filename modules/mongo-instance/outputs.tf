# Output variable definitions

output "mongodb_private_ips" {
    description = "private addr for mongodb instances"
    value = aws_instance.mongodb.*.private_ip
}
