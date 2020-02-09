#--------------------------------------------------------------
# Provider Settings
#--------------------------------------------------------------
provider "aws" {
    shared_credentials_file = "/Users/Please input your user name/.aws/credentials"
    profile                 = "Please input your profile"
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
    key = "production/terraform.tfstate"
    encrypt = true
  }
}

#--------------------------------------------------------------
# Module VPC Settings
#--------------------------------------------------------------
module "module_vpc" {
    source = "../modules/vpc"

    env    = var.env
    cidr   = var.root_segment
}

#--------------------------------------------------------------
# Module Subnet Settings
#--------------------------------------------------------------
module "module_subnet" {
    source = "../modules/subnet"

    env                   = var.env
    segment1_az           = var.segment1_az
    segment2_az           = var.segment2_az
    account_name          = var.account_name
    app_public_segment1   = var.app_public_segment1
    db_private_segment1   = var.db_private_segment1
    db_private_segment2   = var.db_private_segment2

    vpc_id                = module.module_vpc.vpc_id
}

#--------------------------------------------------------------
#  EIP Settings
#--------------------------------------------------------------
module "module_eip" {
    source = "../modules/eip"

    env                   = var.env
    account_name          = var.account_name

    ec2_instance_id        = module.module_ec2.ec2_instance_id
}

#--------------------------------------------------------------
#  Route Table Settings
#--------------------------------------------------------------
module "module_route_table" {
    source = "../modules/route_table"

    env                   = var.env
    account_name          = var.account_name
    
    vpc_id                = module.module_vpc.vpc_id
    db_subnet1_id         = module.module_subnet.db_subnet1_id
    db_subnet2_id         = module.module_subnet.db_subnet2_id
    app_subnet1_id        = module.module_subnet.app_subnet1_id
}

#--------------------------------------------------------------
# Module S3 Settings
#--------------------------------------------------------------
module "module_s3" {
    source = "../modules/s3"
    
    env                 = var.env
    account_name        = var.account_name
    tfstate_bucket_name = var.tfstate_bucket_name
}

#--------------------------------------------------------------
#  SG Settings
#--------------------------------------------------------------
module "module_sg" {
    source = "../modules/sg"

    env                   = var.env
    root_segment          = var.root_segment
    account_name          = var.account_name
    my_global_id          = var.my_global_id

    vpc_id                = module.module_vpc.vpc_id
}

#--------------------------------------------------------------
#  EC2 Settings
#--------------------------------------------------------------
module "module_ec2" {
    source = "../modules/ec2"

    env                      = var.env
    ami                      = var.ami
    ssh_pub                  = var.ssh_pub
    account_name             = var.account_name
    instance_type            = var.instance_type
    
    ec2_sg_id                = module.module_sg.ec2_sg_id
    app_subnet1_id           = module.module_subnet.app_subnet1_id
}

#--------------------------------------------------------------
#  RDS Settings
#--------------------------------------------------------------
module "module_rds" {
    source = "../modules/rds"

    env                         = var.env
    db_name                     = var.db_name
    db_username                 = var.db_username
    db_password                 = var.db_password
    segment1_az                 = var.segment1_az
    account_name                = var.account_name
    db_instance_class           = var.db_instance_class
    db_allocated_storage        = var.db_allocated_storage
    db_backup_retention_period  = var.db_backup_retention_period

    db_sg_id                    = module.module_rds.rds_sg_id
    db_subnet1_id               = module.module_subnet.db_subnet1_id
    db_subnet2_id               = module.module_subnet.db_subnet2_id

}