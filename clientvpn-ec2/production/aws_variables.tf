#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
#AWS Settings
variable "profile" {}
variable "account_id" {}
variable "account_name" {}

#App Name
variable "env" {}
variable "client_domain" {}

#IP Settings
variable "root_segment" {}
variable "app_private_segment1" {}
variable "nat_public_segment" {}
variable "client_vpn_segment" {}
variable "my_global_id" {}
variable "customer_global_ip" {}

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

#vpc endpoint Settings
variable "s3_service_name" {}


