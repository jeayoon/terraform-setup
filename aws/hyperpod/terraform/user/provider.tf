#--------------------------------------------------------------
# terraform
#--------------------------------------------------------------
terraform {
  required_version = "~> 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "" # s3 bucket name
    region  = "ap-northeast-1"
    key     = "hyperpod/user/terraform.tfstate"
    encrypt = true
  }
}

#--------------------------------------------------------------
# Provider
#--------------------------------------------------------------
provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = var.shared_credentials

  default_tags {
    tags = {
      Project     = var.project_name
      Terraform   = "TRUE"
      Environment = var.env
    }
  }
}
