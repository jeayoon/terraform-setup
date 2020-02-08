# terraform vpc ec2 

## AWS infrastructure



## terraform version
```
Terraform v0.12.17
```

## terraform file tree
```
.
├── README.md
├── aws_ec2.tf                      // EC2
├── aws_eip.tf                      // AWS EIP
├── aws_keypair.tf                  // AWS ssh key
├── aws_network.tf                  // AWS VPC, Subnet, RouteTable
├── aws_sg.tf                       // AWS Security Group
├── aws_variables.tf                // Terraform variables
├── main.tf                         // AWS Provider
└── terraform.tfvars                // Terraform input variables
```

## run terraform

```
// Please specify the required values ​​for AWS resources in terraform.tfvars before deploy.

// terraform dry run
$ terraform plan

// terraform deploy
$ terraform apply
```