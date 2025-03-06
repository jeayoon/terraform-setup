#--------------------------------------------------------------
# S3
#--------------------------------------------------------------

# S3 bucket
resource "random_id" "guid" {
  byte_length = 4

  keepers = {
    project = var.project_name
  }
}

# S3 bucket Hyperpod Lifectcle scripts
resource "aws_s3_bucket" "lifecycle_scripts" {
  bucket = join("-", [var.project_name, var.env, var.s3_lifecycle_scripts, random_id.guid.hex])
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.lifecycle_scripts.id

  rule {
    id = "lifecycle_scripts"

    expiration {
      days = 365
    }
    status = "Enabled"
  }
}

resource "aws_s3_object" "lifecycle_scripts" {
  bucket = aws_s3_bucket.lifecycle_scripts.id
  key    = "lifecycle-script-directory/src/"
}

# S3 bucket Hyperpod Backup
resource "aws_s3_bucket" "backup" {
  bucket = join("-", [var.project_name, var.env, var.s3_backup, random_id.guid.hex])
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_full_access" {
  bucket = aws_s3_bucket.backup.id
  policy = templatefile("${path.module}/files/allow_full_s3_access.json.tpl", { s3_name = aws_s3_bucket.backup.id })

  depends_on = [aws_s3_bucket_public_access_block.backup]
}

resource "aws_s3_object" "backup" {
  bucket = aws_s3_bucket.backup.id
  key    = "backup/"
}

# S3 bucket FSx Lustre
resource "aws_s3_bucket" "lustre" {
  bucket = join("-", [var.project_name, var.env, var.s3_lustre, random_id.guid.hex])
}
