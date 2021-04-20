#Codebuild project
resource "aws_codebuild_project" "codebuild_backend" {
  name = "codebuild_backend"
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
    location = "${var.s3_sns_bucket}/backend/cache"
  }

  source { 
    type = "CODEPIPELINE" 
    buildspec = "buildspec.yml"
  }
}

#Codedeploy
resource "aws_codedeploy_app" "codedeploy_backend" {
  compute_platform = "Server"
  name = "codedeploy-backend"
}

resource "aws_codedeploy_deployment_group" "dg_backend" {
  app_name = aws_codedeploy_app.codedeploy_backend.name
  deployment_group_name = "dg-backend"
  service_role_arn = var.codepipeline_role_arn

  ec2_tag_set {
    ec2_tag_filter {
      type = "KEY_AND_VALUE"
      key = "Name" 
      value = var.rolename
    }
  } 

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }
}

#Codepipeline 
resource "aws_codepipeline" "codepipeline_backend" {
  name = "codepipeline-backend"
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
        ProjectName = aws_codebuild_project.codebuild_backend.name
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
        ApplicationName = aws_codedeploy_app.codedeploy_backend.name,
        DeploymentGroupName = aws_codedeploy_deployment_group.dg_backend.deployment_group_name
      }
    }
  }
}
