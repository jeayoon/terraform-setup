terraform {
  required_version = "~> 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "" # s3 bucket name
    region  = "ap-northeast-1"
    key     = "vault/terraform.tfstate"
    encrypt = true
  }
}
