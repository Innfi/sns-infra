
#Codebuild project
resource "aws_codebuild_project" "codebuild_frontend" {
  name = "codebuild_frontend"
  service_role = var.codepipeline_role_arn
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
    location = "${var.s3_sns_bucket}/cache"
  }

  source { 
    type = "CODEPIPELINE" 
    buildspec = "buildspec.yml"
  }
}

#Codedeploy
resource "aws_codedeploy_app" "codedeploy_frontend" {
  compute_platform = "Server"
  name = "codedeploy-frontend"
}

resource "aws_codedeploy_deployment_group" "dg_frontend" {
  app_name = aws_codedeploy_app.codedeploy_frontend.name
  deployment_group_name = "dg-frontend"
  service_role_arn = var.codepipeline_role_arn

  ec2_tag_set {
    ec2_tag_filter {
      type = "KEY_AND_VALUE"
      key = "Role" 
      value = var.rolename
    }
  } 

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }
}

#Codepipeline 
resource "aws_codepipeline" "codepipeline_frontend" {
  name = "codepipeline-frontend"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    location = var.s3_sns_id
    type = "S3"
  }

  stage {
    name = "Source"
    
    action {
      name = "Source" 
      category = "Source" 
      owner = "AWS"
      provider = "CodeStarSourceConnection" 
      version = "1" 
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn = var.codestarconnection_arn
        FullRepositoryId = var.repo_id
        BranchName = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build" 
      category = "Build"
      owner = "AWS" 
      provider = "CodeBuild"
      input_artifacts = ["source_output"] 
      output_artifacts = ["build_output"]
      version = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_frontend.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy" 
      category = "Deploy"
      owner = "AWS" 
      provider = "CodeDeploy"
      input_artifacts = ["build_output"]
      version = "1"

      configuration = {
        ApplicationName = aws_codedeploy_app.codedeploy_frontend.name,
        DeploymentGroupName = aws_codedeploy_deployment_group.dg_frontend.deployment_group_name
      }
    }
  }
}

resource "aws_sns_topic" "noti_frontend" {
  name = "noti_frontend"
}

data "aws_iam_policy_document" "noti_access_frontend" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [ aws_sns_topic.noti_frontend.arn ]
  }
}

resource "aws_sns_topic_policy" "noti_policy_sns" {
  arn = aws_sns_topic.noti_frontend.arn 
  policy = data.aws_iam_policy_document.noti_access_frontend.json
}

resource "aws_codestarnotifications_notification_rule" "noti_frontend_startbuild" {
  name = "noti_frontend_startbuild"

  detail_type = "BASIC"
  event_type_ids = ["codebuild-project-build-state-in-progress"]
  resource = aws_codebuild_project.codebuild_frontend.arn 
  target {
    address = aws_sns_topic.noti_frontend.arn
  }
}

