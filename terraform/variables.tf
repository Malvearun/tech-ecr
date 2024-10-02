variable "region" {
  description = "AWS Region"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "flask-app"
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "aws_profile" {
  description = "aws profile name"
  type        = string
}
