# VPC & EC2 & RDS

## AWS infrastructure

<img width="700" alt="スクリーンショット 2020-02-09 16 54 54" src="https://user-images.githubusercontent.com/17561411/74098549-edfbd480-4b5c-11ea-8d3f-b8b687433a94.png">

## terraform version
```
Terraform v0.12.19
```

## terraform file tree
```
.
├── README.md
├── modules
│   ├── ec2                         // AWS EC2
│   ├── eip                         // AWS Elastic IP
│   ├── rds                         // AWS RDS (mysql)
│   ├── route_table                 // AWS RouteTable
│   ├── s3                          // AWS S3
│   ├── sg                          // AWS Security Group
│   ├── subnet                      // AWS Subnet
│   └── vpc                         // AWS VPC
└── production
    ├── aws_variables.tf            // Terraform variables
    ├── main.tf                     // AWS Provider & Call Modules
    └── terraform.tfvars            // Terraform input variables
```

## run terraform

```
// Please specify the required values ​​for AWS resources in production/terraform.tfvars before deploy.

// terraform dry run
$ production/terraform plan

// terraform deploy
$ production/terraform apply
```