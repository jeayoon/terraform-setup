variable "shared_credentials" {
  type        = list(string)
  default     = ["~/.aws/credentials"]
  description = "Path of the AWS credentials"
}

variable "project_name" {
  type        = string
  description = "project name"
  default     = "leo"
}

variable "env" {
  type        = string
  description = "Environment"
  default     = "stg"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "access_key_dir" {
  type        = string
  description = "Access Key Download Dir"
  default     = "~/Downloads/AWS_HyperPod_AccessKey/"
}
