# ec2 instance for frontend 
resource "aws_instance" "frontend" {
    count = length(var.azs)

    ami = var.ec2_ami_frontend
    instance_type = var.ec2_type_frontend
    key_name = var.key_pair

    subnet_id = var.subnets_public.*[count.index]
    vpc_security_group_ids = [
        var.security_group_public
    ]

    tags = merge (
        {
            "Name" = format("%s-frontend-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags
    )
}