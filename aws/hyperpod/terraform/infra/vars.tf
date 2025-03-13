variable "shared_credentials" {
  type        = list(string)
  default     = ["~/.aws/credentials"]
  description = "Path of the AWS credentials"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-1"
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

variable "tokyo_az_1a_zone_id" {
  type        = string
  description = "ap-northeast-1a Zone ID"
  default     = "apne1-az4"
}

variable "tokyo_az_1c_zone_id" {
  type        = string
  description = "ap-northeast-1c Zone ID"
  default     = "apne1-az1"
}
variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}
variable "vpc_cidr_block2" {
  type        = string
  description = "vpc cidr block2"
  default     = "10.1.0.0/16"
}

variable "create_s3_endpoint" {
  type        = string
  description = "Create an S3 endpoint"
  default     = "true"
}

variable "capacity" {
  type        = number
  description = "Storage capacity in GiB (1200 or increments of 2400)"
  default     = 1200
}

variable "per_unit_storage_throughput" {
  type        = number
  description = "Provisioned Read/Write (MB/s/TiB)"
  default     = 125
}

variable "compression" {
  type        = string
  description = "Data compression type"
  default     = "LZ4"
}

variable "s3_lifecycle_scripts" {
  type        = string
  description = "S3 Bucket to save lifecycle configuration file"
  default     = "hyperpod-lifecycle"
}

variable "s3_backup" {
  type        = string
  description = "S3 Bucket to save backup file"
  default     = "hyperpod-backup"
}

variable "s3_lustre" {
  type        = string
  description = "S3 Bucket to save fsx lustre"
  default     = "fsx-lustre"
}
