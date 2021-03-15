# security group for mongodb
resource "aws_security_group" "mongodb" {
    name = "SecurityGroupMongoDB" 
    vpc_id = var.vpc_id

    ingress {
        description = "mongodb"
        from_port = var.mongodb_port
        to_port = var.mongodb_port
        protocol = "tcp"
        security_groups = [
            var.security_group_db
        ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        {
            "Name" = "MongoDB"
        },
        var.tags, 
        var.vpc_tags,
    )
}

# ec2 instance for mongodb
resource "aws_instance" "mongodb" {
    count = length(var.azs) 

    ami = var.ec2_ami_mongodb
    instance_type = var.ec2_type_mongodb
    key_name = var.key_pair

    subnet_id = var.subnets_db.*[count.index]
    vpc_security_group_ids = [
        var.security_group_db, 
        aws_security_group.mongodb.id
    ]

    tags = merge (
        {
            "Name" = format("%s-mongodb-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags
    )
}