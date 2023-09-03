#--------------------------------------------------------------
# Provider Settings
#--------------------------------------------------------------
provider "aws" {
    shared_credentials_files = ["~/.aws/credentials"]
    region                  = "ap-northeast-1"
}

#--------------------------------------------------------------
# backend (tfstate)
#--------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "Please input your bucket name"      # s3 bucket name
    region = "ap-northeast-1"
    key = "test/terraform.tfstate"
    encrypt = true
  }
}