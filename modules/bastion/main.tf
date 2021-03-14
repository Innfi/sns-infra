# bastion security group
resource "aws_security_group" "bastion" {
    name = "SecurityGroupBastion"
    vpc_id = var.vpc_id

    ingress {
        description = "ssh"
        from_port = var.bastion_ssh_port
        to_port = var.bastion_ssh_port
        protocol = "tcp"
        cidr_blocks = var.internal_cidrs
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        {
            "Name" = "Bastion"
        },
        var.tags, 
        var.vpc_tags,
    )
}

# add bastion sg to vpc sgs
resource "aws_security_group_rule" "ingress_bastion" {
    security_group_id = var.security_group_public

    type = "ingress" 
    from_port = var.bastion_ssh_port
    to_port = var.bastion_ssh_port 
    protocol = "tcp" 
    source_security_group_id = aws_security_group.bastion.id
}

# ec2 instance for bastion
resource "aws_instance" "bastion" {
    count = length(var.azs) 

    ami = var.ec2_ami_bastion
    instance_type = var.ec2_type_bastion
    key_name = var.key_pair

    subnet_id = var.subnets_bastion.*[count.index]
    vpc_security_group_ids = [
        aws_security_group.bastion.id
    ]

    tags = merge (
        {
            "Name" = format("%s-bastion-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags
    )
}
