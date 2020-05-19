# Client vpn & EC2

## AWS infrastructure

<img width="700" alt="スクリーンショット 2020-02-09 1 44 24" src="https://user-images.githubusercontent.com/17561411/74088811-be59b780-4add-11ea-9faa-d635a01442ed.png">

## terraform version
```
Terraform v0.12.19
```

## terraform file tree
```
.
├── README.md
├── modules
│   ├── client_vpn                  // AWS Client VPN
│   ├── cloudwatch                  // AWS CloudWatch
│   ├── data_source                 // AWS ACM Certificate
│   ├── ec2                         // AWS EC2
│   ├── eip                         // AWS Elastic IP
│   ├── role                        // AWS Role (EC2, S3)
│   ├── route53                     // AWS Route53
│   ├── route_table                 // AWS RouteTable
│   ├── s3                          // AWS S3
│   ├── sg                          // AWS Security Group
│   ├── subnet                      // AWS Subnet
│   ├── vpc                         // AWS VPC
│   └── vpc_endpoint                // AWS VPC Endpoint
└── production
    ├── aws_variables.tf            // Terraform variables
    ├── main.tf                     // AWS Provider & Call Modules
    └── terraform.tfvars            // Terraform input variables
```

## Make Client Certificate and Deploy to AWS ACM Certificate

```

# git clone easy-rsa.git
git clone https://github.com/OpenVPN/easy-rsa.git
 
cd easy-rsa/easyrsa3
 
# PKI Initialization
./easyrsa init-pki

# Build CA
./easyrsa build-ca nopass
 
# Enter a name as you are asked for the Common Name
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:my-common-name
 
# make server certificate
./easyrsa build-server-full {$your-domain} nopass
 
# make client certificate
./easyrsa build-client-full {$your-domain} nopass

mkdir tmp
cp pki/ca.crt tmp/
cp pki/issued/server.crt tmp
cp pki/private/server.key tmp
cp pki/issued/{$your-domain} tmp
cp pki/private/{$your-domain} tmp
cd tmp
 
# Upload server certificate and key to AWS ACM Certificate
aws acm import-certificate --certificate file://server.crt --private-key file://server.key --certificate-chain file://ca.crt --profile {user_name} —region {region}
## ARN is returned on success
{
 "CertificateArn": "arn:aws:acm:ap-northeast-1:0123456789:certificate/hogehoge-hoge-hoge-hoge-hogehoge"
}
 
# Upload client certificate and key to AWS ACM Certificate
aws acm import-certificate --certificate file://{$your-domain}.crt --private-key file://{$your-domain}.key --certificate-chain file://ca.crt --profile {user_name} --region {region}
## ARN is returned on success
{
 "CertificateArn": "arn:aws:acm:ap-northeast-1:0123456789:certificate/hogehoge-hoge-hoge-hoge-hogehoge"
}
```

## run terraform

```
// Please specify the required values ​​for AWS resources in production/terraform.tfvars before deploy.

// terraform dry run
$ production/terraform plan

// terraform deploy
$ production/terraform apply
```
