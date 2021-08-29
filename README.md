# Repository: sns-infra
IaC for social network service based on AWS

# Tools
* terraform
* ansible

# Modules

* [VPC](./modules/vpc/main.tf): basic network infrastructures
* [frontend](./modules/frontend/main.tf): frontend instances (EC2) with ALB 
* [backend](./modules/backend/main.tf): backend instances (EC2) with ALB
* [bastion](./modules/bastion/main.tf): maintenance
* [cicd-baseline](./modules/cicd-baseline/main.tf): CodePipeline roles, S3 buckets, CodeStar connections
* [codepipeline-frontend](./modules/codepipeline-frontend/main.tf): CodePipeline for frontend 
* [codepipeline-backend](./modules/codepipeline-backend/main.tf): CodePipeline for backend

# To be included

* Persistence: MongoDB, Redis, etc
* CDN: CloudFront 

