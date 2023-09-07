terraform {
  required_providers {
    aws = {
      version = "= 4.65.0"
    }
  }
}
provider "aws" {
  region = "ap-northeast-1"
}
