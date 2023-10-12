variable "region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS tokyo region"
}

variable "shared_credentials" {
  type        = list(string)
  default     = ["~/.aws/credentials"]
  description = "Path of the AWS credentials"
}

variable "tags" {
  type = map(string)
  default = {
    env = "fargate_cicd_dev"
  }
  description = "AWS tags"
}

variable "cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr"
}

variable "cloudwatch_log_group_name" {
  type        = string
  default     = "/ecs/logs/terraform/nginx"
  description = "AWS Fargate CloudWatch Log Group Name"
}

variable "container_port" {
  type        = number
  default     = 80
  description = "Ingres and egress port of the container"
}

variable "container_name" {
  type        = string
  default     = "nginx_container"
  description = "Container Name"
}
