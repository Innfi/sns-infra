# ec2 instance for mongodb
resource "aws_instance" "mongodb" {
    count = length(var.azs) 

    ami = var.ec2_ami_mongodb
    instance_type = var.ec2_type_mongodb
    key_name = var.key_pair

    subnet_id = var.subnets_db.*[count.index]
    vpc_security_group_ids = [
        var.security_group_db
    ]

    tags = merge (
        {
            "Name" = format("%s-mongodb-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags
    )
}