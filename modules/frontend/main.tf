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

    iam_instance_profile = var.general_instance_profile_name

    tags = merge (
        {
            "Name" = format("%s-frontend-%s", var.name, var.azs[count.index]),
            "Role" = var.rolename
        },
        var.tags, 
        var.vpc_tags
    )
}

# ALB target group
resource "aws_lb_target_group" "tg_frontend" {
    name = format("%s-targetgroup", var.name)
    port = var.port_http 
    protocol = "HTTP"
    vpc_id = var.vpc_id
}

resource "aws_lb_target_group_attachment" "public" {
    count = length(aws_instance.frontend)

    target_group_arn = aws_lb_target_group.tg_frontend.arn
    target_id = aws_instance.frontend.*.id[count.index]
    port = var.port_http
}

# ALB
resource "aws_lb" "alb_frontend" {
    name = format("%s-alb-frontend", var.name)
    internal = false 
    load_balancer_type = "application"

    security_groups = [
        aws_security_group.alb.id  #FIXME
    ]

    subnets = aws_subnet.public.*.id

    tags = merge (
        {
            "Name" = format("%s-frontend-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags
    )
}

resource "aws_lb_listener" "listener_frontend" {
    load_balancer_arn = aws_lb.alb_frontend.arn 
    port = var.port_http 
    protocol = "HTTP"

    default_action {
        type = "forward" 
        target_group_arn = aws_lb_target_group.tg_frontend.arn
    }
}