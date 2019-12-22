# terraform codepipeline(ver.ecs rolling update) & slack notifications

## terraform version
```
Terraform v0.12.9

If your Terraform version is 0.12.17 please remove `${}` in tf files.
For examples `${var.account_id}` >> `var.account_id`
```

## terraform file tree
```
.
├── README.md
├── aws_codepipeline.tf             // AWS CodePipeline settings 
├── aws_codepipeline_slack.tf       // AWS CodePipeline slack notifications
├── aws_role_policy.tf              // AWS role & policies settiongs
├── aws_s3.tf                       // AWS s3 settings
├── aws_variables.tf                // Terraform variables
├── functions                       // Lambda functions files
│   └── notifications
├── main.tf                         // AWS main(access)
├── policies                        
│   └── codepipeline                // AWS CodePipeline Policy json files
└── terraform.tfvars                // Terraform input variables
```