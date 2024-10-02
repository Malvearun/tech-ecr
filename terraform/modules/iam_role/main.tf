# modules/iam/main.tf

resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "ecr_role" {
  name = var.ecr_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecr.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_role_name}-policy"
  description = "Lambda policy for executing Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = "ecr:GetDownloadUrlForLayer"
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "ecr:BatchGetImage"
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "ecr:BatchCheckLayerAvailability"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.ecr_role_name}-policy"
  description = "ECR policy for accessing the ECR repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = [
        "ecr:GetAuthorizationToken",
        "ect:InitialLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.ecr_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "ecr_role_arn" {
  value = aws_iam_role.ecr_role.arn
}
