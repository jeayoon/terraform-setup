# Sagemaker Hyperpod Infra

## Based

[Hyperpod Infra Cloudformation Template DL](https://awsome-distributed-training.s3.amazonaws.com/templates/sagemaker-hyperpod.yaml)

## Prerequisite

- AWS CLI
- Terraform (&tfenv)

## Terraform Information

### Resources

- VPC
- Subnet
- Route Table
- Security Groups
- IGW
- NAT
- FSx
- S3

### Terraform version

```
# 1.8.* OK
Terraform v1.8.5
```

### Terraform setup

#### AWS Credentials

Configure [~/.aws/credentials](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-files.html)

#### Backend
```
in provider.tf

backend "s3" {
    bucket  = "${YOUR_S3_BUCHEK_NAME}"
    region  = "ap-northeast-1"
    key     = "hyperpod/terraform.tfstate"
    encrypt = true
  }
```
### Running Terraform

```
terraform init
```
```
terraform plan
```
```
terraform apply
```
```
terraform destroy
```
## Running Sagemaker Hyperpod Cluster

[Navigate to the Hyperpod folder](https://gitlab.mzcloud.xyz/mz-jp/Cloud-SA/leo-tech/-/tree/main/hyperpod-vpc-terraform/hyperpod?ref_type=heads)