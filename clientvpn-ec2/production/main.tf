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
    account_name          = var.account_name
    nat_public_segment    = var.nat_public_segment
    app_private_segment1  = var.app_private_segment1

    vpc_id                = module.module_vpc.vpc_id
}

#--------------------------------------------------------------
#  EIP Settings
#--------------------------------------------------------------
module "module_eip" {
    source = "../modules/eip"

    env                   = var.env
    account_name          = var.account_name
}

#--------------------------------------------------------------
#  Route Table Settings
#--------------------------------------------------------------
module "module_route_table" {
    source = "../modules/route_table"

    env                   = var.env
    account_name          = var.account_name
    
    vpc_id                = module.module_vpc.vpc_id
    nat_eip_id            = module.module_eip.nat_eip_id
    nat_subnet_id         = module.module_subnet.nat_subnet_id
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
    customer_global_ip    = var.customer_global_ip
    client_vpn_segment    = var.client_vpn_segment

    vpc_id                = module.module_vpc.vpc_id
    client_vpn_sg         = module.module_client_vpn.client_vpn_sg
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
    ec2_instance_role_name   = module.module_role.ec2_instance_role_name
}

#--------------------------------------------------------------
#  DATA Source Settings
#--------------------------------------------------------------
module "module_data_source" {
    source = "../modules/data_source"

    client_domain         = var.client_domain
}

#--------------------------------------------------------------
#  Client VPN Settings
#--------------------------------------------------------------
module "module_client_vpn" {
    source = "../modules/client_vpn"

    env                        = var.env
    account_name               = var.account_name
    client_cidr_block          = var.client_vpn_segment

    nat_subnet_id              = module.module_subnet.nat_subnet_id
    app_subnet1_id             = module.module_subnet.app_subnet1_id
    server_certificate_arn     = module.module_data_source.acm_server_cert_arn
    client_certificate_arn     = module.module_data_source.acm_client_cert_arn
    client_vpn_log_group_name  = module.module_cloudwatch.client_vpn_log_group_name
    client_vpn_log_stream_name = module.module_cloudwatch.client_vpn_log_stream_name
}

#--------------------------------------------------------------
#  CloudWatch Settings
#--------------------------------------------------------------
module "module_cloudwatch" {
    source = "../modules/cloudwatch"

    env                    = var.env
    account_name           = var.account_name
}

#--------------------------------------------------------------
#  CloudWatch Settings
#--------------------------------------------------------------
module "module_role" {
    source = "../modules/role"

    env                    = var.env
    account_name           = var.account_name
}

#--------------------------------------------------------------
#  VPC Endpoint Settings
#--------------------------------------------------------------
module "module_vpc_endpoint" {
    source = "../modules/vpc_endpoint"

    env                     = var.env
    account_name            = var.account_name
    s3_service_name         = var.s3_service_name

    vpc_id                  = module.module_vpc.vpc_id
    private_route_table_id  = module.module_route_table.private_route_table_id
}

#--------------------------------------------------------------
#  Route53 Settings
#--------------------------------------------------------------
module "module_route53" {
    source = "../modules/route53"

    env                     = var.env
    account_name            = var.account_name
    client_domain           = var.client_domain

    ec2_private_id          = module.module_ec2.ec2_private_id
}