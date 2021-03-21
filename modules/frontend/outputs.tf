# Output variable definitions 

output "frontend_public_dns" {
    description = "public dns for frontend instances"
    value = aws_instance.frontend.*.public_dns
}