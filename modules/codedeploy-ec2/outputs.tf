# Output variable definitions

output "codedeploy_app_id" {
    description = "CodeDeploy Application ID"
    value = aws_codedeploy_app.sns-v1-deploy.id
}

