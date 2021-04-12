# S3 bucket for artifacts

resource "aws_s3_bucket" "sns-v2" {
    bucket = "sns-v2"
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

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service" : [
            "cloudwatch.amazonaws.com",
            "events.amazonaws.com",
            "codebuild.amazonaws.com",
            "codedeploy.amazonaws.com", 
            "codepipeline.amazonaws.com",
            "codestar.amazonaws.com"
          ]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
    name = "codepipeline_role_policy"
    role = aws_iam_role.codepipeline_role.id

    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
            "Action": [
              "s3:*"
            ],
            "Effect": "Allow",
            "Resource": [
              aws_s3_bucket.sns-v2.arn,
              "${aws_s3_bucket.sns-v2.arn}/*"
            ]
          },
          {
            "Action": [
              "codebuild:*",
              "codedeploy:*",
              "codepipeline:*",
              "codestar:*",
              "codestar-connections:*",
              "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
          }
      ]
    })
}

#Codestar connections for github
resource "aws_codestarconnections_connection" "connection_github" {
  name = "connection_github2"
  provider_type = "GitHub"
}
