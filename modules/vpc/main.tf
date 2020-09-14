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

# subnet
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

# routing table
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

# route table association

resource "aws_route_table_association" "public" {
    count = length(var.azs)

    subnet_id = aws_subnet.public.*.id[count.index]
    route_table_id = aws_route_table.public.*.id[count.index]
}

# security group
resource "aws_security_group" "public" {
    vpc_id = local.vpc_id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        {
            "Name" = format("%s-public", var.name)
        },
        var.tags, 
        var.vpc_tags,
    )
}

resource "aws_security_group_rule" "public_http" {
    security_group_id = aws_security_group.public.id
    type = "ingress" 
    from_port = var.port_http
    to_port = var.port_http
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_ssh" {
    security_group_id = aws_security_group.public.id
    type = "ingress" 
    from_port = var.port_ssh
    to_port = var.port_ssh
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
}

#s3

resource "aws_s3_bucket" "sns-v1" {
    bucket = "sns-v1"
    acl = "private"

    tags = merge(
        {
            "Name" = format("%s-public", var.name)
        },
        var.tags, 
        var.vpc_tags,
    )
}

#service role
resource "aws_iam_role" "ec2_deploy_role" {
    name = "ec2_deploy_role"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_deploy_policy" {
    name = "ec2_deploy_policy" 
    role = aws_iam_role.ec2_deploy_role.id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*",
                "codedeploy:*"
            ], 
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_deploy_profile" {
    name = "deploy_profile"
    role = aws_iam_role.ec2_deploy_role.name
}

#ec2 web
resource "aws_instance" "web" {
    count = length(var.azs)

    ami = var.ec2_ami_web
    instance_type = var.ec2_type_web
    key_name = var.key_pair

    subnet_id = aws_subnet.public.*.id[count.index]
    vpc_security_group_ids = [
        aws_security_group.public.id
    ]

    iam_instance_profile = aws_iam_instance_profile.ec2_deploy_profile.name

    tags = merge(
        {
            "Name" = format("%s-web-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags,
    )
}
