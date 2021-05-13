# Output variable definitions

output "vpc_id" {
    description = "vpc id"
    value = aws_vpc.this.id
}

output "subnet_id_public" {
    description = "public subnet ids"
    value = aws_subnet.public.*.id
}

output "sg_id_public" {
    description = "public security group id"
    value = aws_security_group.public.id
}

#output "subnet_id_private" {
#    description = "private subnet ids"
#    value = aws_subnet.private.*.id
#}
#
#output "sg_id_private" {
#    description = "private security group id"
#    value = aws_security_group.private.id
#}

output "general_instance_profile_name" {
    description = "instance profile name for ec2 instances"
    value = aws_iam_instance_profile.general_instance_profile.name
}