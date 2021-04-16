# Output variable definitions 

output "frontend_public_dns" {
    description = "public dns for frontend instances"
    value = aws_instance.frontend.*.public_dns
}

output "frontend_private_ips" {
    description = "private addr for backend instances" 
    value = aws_instance.frontend.*.private_ip
}