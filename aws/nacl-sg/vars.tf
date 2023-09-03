# prj
variable "project_name" {} 
variable "environment" {}

# network
variable "cidr_vpc" {}
variable "cidr_public1" {}
variable "cidr_public2" {}
variable "cidr_public3" {}
variable "cidr_public4" {}
variable "cidr_private1" {}
variable "cidr_private2" {}
variable "cidr_private3" {}
variable "cidr_private4" {}

# Bastion
variable "bastion_ami" {}
variable "bastion_instance_type" {}
variable "bastion_volume_size" {}

# Private EC2
variable "Private_EC2_ami" {}
variable "Private_EC2_instance_type" {}
variable "Private_EC2_volume_size" {}