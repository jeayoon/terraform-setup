#--------------------------------------------------------------
# S3 bucket Setting
#--------------------------------------------------------------
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.artifact_bucket_name}"
  acl    = "private"
}

#--------------------------------------------------------------
# s3kmskey Settings
#--------------------------------------------------------------

data "aws_kms_alias" "s3kmskey" {
  name = "alias/aws/s3"
}