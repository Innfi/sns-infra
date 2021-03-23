# S3 bucker for artifacts
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

# IAM service for for codepipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service" : [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com", 
          "codepipeline.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
    name = "codepipeline_role_policy"
    role = aws_iam_role.codepipeline_role.id

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": [
          "${aws_s3_bucket.sns-v1.arn}",
          "${aws_s3_bucket.sns-v1.arn}/*"
        ]
      },
      {
        "Action": [
          "codebuild:*",
          "codedeploy:*",
          "codepipeline:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
  ]
}
EOF
}
