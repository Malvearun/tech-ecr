# modules/iam/output.tf

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "ecr_role_arn" {
  value = aws_iam_role.ecr_role.arn
}
