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

#codepipeline 
resource "aws_codepipeline" "codepipeline_frontend" {
  name = "codepipeline-frontend"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.sns-v1.bucket
    type = "S3"
  }

  stage {
    name = "Source"
    
    action {
      name = "Source" 
      category = "Source" 
      owner = "ThirdParty"
      provider = "GitHub" 
      version = "1" 
      output_artifacts = ["source_output"]

      configuration = {
        Owner = "innfi"
        Repo = "https://github.com/innfi/snd-frontend"
        Branch = "main"
        OAuthToken = "f1c80ab81b9238bfe345f88e53d5e31690f8389d"
      }
    }
  }

  stage {
    name =  "Build"
    action {
      name = "Build" 
      category = "Build"
      owner = "AWS" 
      provider = "Codebuild"
      input_artifacts = ["source_output"] 
      output_artifacts = ["build_output"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_frontend.name
      }
    }
  }
}

resource "aws_codebuild_project" "codebuild_frontend" {
  name = "codebuild_frontend"
  service_role = aws_iam_role.codepipeline_role.arn
  artifacts {
    type = "CODEPIPELINE"
  } 

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:3.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true
  }

  cache {
    type = "S3"
    location = "${aws_s3_bucket.sns-v1.bucket}/cache"
  }

  source { 
    type = "CODEPIPELINE" 
    buildspec = "buildspec.yml"
  }
}