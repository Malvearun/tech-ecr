provider "aws" {
  region = var.region
  profile = var.aws_profile 
}

# ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.app_name}-repo"
  image_tag_mutability = "MUTABLE"
}

# Lambda Role
resource "aws_iam_role" "lambda_role" {
  name               = "${var.app_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda Function
resource "aws_lambda_function" "flask_lambda" {
  function_name     = "${var.app_name}-lambda"
  image_uri         = "${aws_ecr_repository.app_repo.repository_url}:latest"
  role              = aws_iam_role.lambda_role.arn
  package_type      = "Image"
  timeout           = 15

  environment {
    variables = {
      ENV = var.env
    }
  }

  depends_on = [aws_ecr_repository.app_repo]
}

# Output Lambda URL
output "lambda_url" {
  value = aws_lambda_function.flask_lambda.invoke_arn
}
