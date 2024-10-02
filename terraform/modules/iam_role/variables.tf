# modules/iam/variables.tf

variable "lambda_role_name" {
  description = "Name of the Lambda IAM role"
  type        = string
}

variable "ecr_role_name" {
  description = "Name of the ECR IAM role"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the Lambda function"
  type        = string
}

