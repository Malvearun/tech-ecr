# modules/lambda/variables.tf

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the AWS Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role that the Lambda function assumes"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the Lambda function"
  type        = string
}