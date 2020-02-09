#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
#AWS Settings
variable "profile" {}
variable "account_id" {}
variable "account_name" {}

#App Name
variable "env" {}

#IP Settings
variable "root_segment" {}
variable "app_public_segment1" {}
variable "db_private_segment1" {}
variable "db_private_segment2" {}
variable "my_global_id" {}

#AZ Settings
variable "segment1_az" {}
variable "segment2_az" {}
variable "segment3_az" {}

#tfstate Settings
variable "tfstate_bucket_name" {}

#ec2 Settings
variable "ami" {}
variable "instance_type" {}
variable "ssh_pub" {}

#rds Settings
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_instance_class" {}
variable "db_allocated_storage" {}
variable "db_backup_retention_period" {}
