# Input variable definitions

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "rolename" {
  description = "Role name of frontend instances for Codedeploy DG"
  type = string 
}

variable "s3_sns_bucket" {
  description = "s3 bucket for codepipeline"
  type = string 
}

variable "s3_sns_id" {
  description = "s3 id for codepipeline"
  type = string
}

variable "codepipeline_role_arn" {
  description = "iam role arn for codepipeline"
  type = string 
}

variable "codestarconnection_arn" {
  description = "codestarconnection arn for codepipeline"
  type = string
}

variable "repo_id" {
  description = "repository id for frontend"
  type = string
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
