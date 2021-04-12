# Output variable definitions 

output "s3_sns_bucket" {
    description = "s3 bucket for codepipeline"
    value = aws_s3_bucket.sns-v2.bucket
}

output "s3_sns_id" {
    description = "s3 id for codepipeline"
    value = aws_s3_bucket.sns-v2.id
}

output "codepipeline_role_arn" {
    description = "iam role arn for codepipeline" 
    value = aws_iam_role.codepipeline_role.arn
}

output "codestarconnection_arn" {
    description = "codestarconnection arn for codepipeline"
    value = aws_codestarconnections_connection.connection_github.arn
}