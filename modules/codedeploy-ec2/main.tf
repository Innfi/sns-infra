# iam role
resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws-codedeploy-role" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    role = aws_iam_role.codedeploy_role.name
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

# codedeploy app
resource "aws_codedeploy_app" "sns-v1-deploy" {
    compute_platform = "Server"
    name = "sns-v1-deploy"
}
