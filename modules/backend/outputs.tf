# Output variable definitions 

output "backend_private_ips" {
    description = "private addr for backend instances" 
    value = aws_instance.backend.*.private_ip
}