# Setup the AWS provider | provider.tf

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version     = "~> 2.12"
  region      = var.aws_region
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
}
