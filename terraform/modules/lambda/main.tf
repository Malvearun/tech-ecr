# modules/lambda/main.tf

resource "aws_ecr_repository" "this" {
  name = var.repository_name
}

resource "aws_lambda_function" "this" {
  function_name = var.lambda_function_name
  image_uri     = "${aws_ecr_repository.this.repository_url}:latest"

  package_type = "Image"
  role         = var.lambda_role_arn

  lifecycle {
    ignore_changes = [image_uri]  # Prevent Terraform from updating the image URI automatically
  }
}
