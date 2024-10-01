output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.flask_lambda.function_name
}
