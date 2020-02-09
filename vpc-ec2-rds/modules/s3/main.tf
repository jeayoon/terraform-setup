#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "account_name" {}
variable "tfstate_bucket_name" {}


#--------------------------------------------------------------
# S3 Bucket (tfstate)
#--------------------------------------------------------------
resource "aws_s3_bucket" "terraform_tfstate" {
  bucket = "${var.account_name}-${var.tfstate_bucket_name}"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
