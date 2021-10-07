# ec2 instance for backend 
resource "aws_instance" "backend" {
    count = length(var.azs) 

    ami = var.ec2_ami_backend 
    instance_type = var.ec2_type_backend
    key_name = var.key_pair

    subnet_id = var.subnets_private.*[count.index]
    vpc_security_group_ids = [
        var.security_group_private
    ]

    tags = merge (
        {
            "Name" = format("%s-backend-%s", var.name, var.azs[count.index])
        },
        var.tags, 
        var.vpc_tags
    )
}

resource "aws_s3_bucket" "media-bucket" {
    bucket = var.media_bucket_name 
    acl = var.media_bucket_acl

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT", "POST", "GET"]
        allowed_origins = ["*"] #FIXME
    }
}