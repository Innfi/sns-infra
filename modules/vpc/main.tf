# locals
locals {
    vpc_id = aws_vpc.this.id
}

# vpc
resource "aws_vpc" "this" {
    cidr_block = var.cidr
    instance_tenancy = "default" 
    enable_dns_hostnames = true

    tags = merge(
        {
            "Name" = format("%s", var.name)
        },
        var.tags, 
        var.vpc_tags,
    )
}

# internet gateway
resource "aws_internet_gateway" "gateway" {
    vpc_id = local.vpc_id

    tags = merge(
        {
            "Name" = format("%s", var.name)
        },
        var.tags, 
        var.vpc_tags,
    )
}

# public subnet
resource "aws_subnet" "public" {
    count = length(var.subnet_public)

    vpc_id = local.vpc_id
    availability_zone = var.azs[count.index]
    cidr_block = var.subnet_public[count.index]

    map_public_ip_on_launch = true

    tags = merge(
        {
            "Name" = format("%s-public-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags,
    )
}

# public routing table
resource "aws_route_table" "public" {
    count = length(var.azs) 

    vpc_id = local.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }

    tags = merge(
        {
            "Name" = format("%s-public-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags,
    )
}

# public route table association
resource "aws_route_table_association" "public" {
    count = length(var.azs)

    subnet_id = aws_subnet.public.*.id[count.index]
    route_table_id = aws_route_table.public.*.id[count.index]
}

# public security group
resource "aws_security_group" "public" {
    vpc_id = local.vpc_id

    tags = merge(
        {
            "Name" = format("%s-public", var.name)
        },
        var.tags, 
        var.vpc_tags,
    )
}

resource "aws_security_group_rule" "ingress_public" {
    security_group_id = aws_security_group.public.id

    type = "ingress" 
    from_port = var.port_http
    to_port = var.port_http
    protocol = "tcp"
    cidr_blocks = var.internal_cidrs
}

resource "aws_security_group_rule" "egress_public" {
    security_group_id = aws_security_group.public.id

    type = "egress" 
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}

## private subnet 
#resource "aws_subnet" "private" {
#    count = length(var.subnet_private)
#
#    vpc_id = local.vpc_id
#    availability_zone = var.azs[count.index]
#    cidr_block = var.subnet_private[count.index]
#
#    tags = merge(
#        {
#            "Name" = format("%s-private-%s", var.name, var.azs[count.index])
#        },
#        var.tags, 
#        var.vpc_tags,
#    )
#}
#
## eip for NAT gateway
#resource "aws_eip" "nat_eip" {
#    count = length(var.azs)
#
#    vpc = true
#}
#
## NAT gateway
#resource "aws_nat_gateway" "this" {
#    count = length(var.azs)
#
#    allocation_id = aws_eip.nat_eip.*.id[count.index]
#    subnet_id = aws_subnet.public.*.id[count.index]
#
#    tags = merge(
#        {
#            "Name" = format("%s-%s", var.name, var.azs[count.index])
#        },
#        var.tags, 
#        var.vpc_tags,
#    )
#}
#
## private routing table 
#resource "aws_route_table" "private" {
#    count = length(var.azs)
#
#    vpc_id = local.vpc_id
#
#    route {
#        cidr_block = "0.0.0.0/0"
#        nat_gateway_id = aws_nat_gateway.this.*.id[count.index]
#    }
#
#    tags = merge(
#        {
#            "Name" = format("%s-private-%s", var.name, var.azs[count.index])
#        },
#        var.tags, 
#        var.vpc_tags,
#    )
#}
#
## private route table association
#resource "aws_route_table_association" "private" {
#    count = length(var.azs)
#
#    subnet_id = aws_subnet.private.*.id[count.index]
#    route_table_id = aws_route_table.private.*.id[count.index]
#}
#
## private security group
#resource "aws_security_group" "private" {
#    vpc_id = local.vpc_id
#
#    tags = merge(
#        {
#            "Name" = format("%s-private", var.name)
#        },
#        var.tags, 
#        var.vpc_tags,
#    )
#}
#
#resource "aws_security_group_rule" "ingress_private" {
#    security_group_id = aws_security_group.private.id
#
#    type = "ingress" 
#    from_port = var.port_was
#    to_port = var.port_was
#    protocol = "tcp"
#    source_security_group_id = aws_security_group.public.id
#}
#
#resource "aws_security_group_rule" "egress_private" {
#    security_group_id = aws_security_group.private.id
#
#    type = "egress" 
#    from_port = 0
#    to_port = 0
#    protocol = -1
#    cidr_blocks = ["0.0.0.0/0"]
#}
#
## IAM role to access s3 
#resource "aws_iam_role" "s3_role" {
#    name = "ec2_general_role"
#
#  assume_role_policy = jsonencode({
#    "Version": "2012-10-17",
#    "Statement": [
#      {
#        "Action": "sts:AssumeRole"
#        "Effect": "Allow",
#        "Sid": "",
#        "Principal": {
#          "Service" : "ec2.amazonaws.com"
#        },
#      }
#    ]
#  })
#}