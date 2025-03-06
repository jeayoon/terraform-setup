#--------------------------------------------------------------
# FSx for Lustre
#--------------------------------------------------------------
resource "aws_fsx_lustre_file_system" "lustre" {
  storage_capacity            = var.capacity
  subnet_ids                  = [aws_subnet.private01.id]
  security_group_ids          = [aws_security_group.efa_sg.id]
  per_unit_storage_throughput = var.per_unit_storage_throughput
  deployment_type             = "PERSISTENT_2"
  data_compression_type       = var.compression
  metadata_configuration {
    mode = "AUTOMATIC"
  }

  tags = {
    Name = join("-", [var.project_name, var.env, "lustre01"])
  }
}

resource "aws_fsx_data_repository_association" "data_repo_assoc1" {
  file_system_id       = aws_fsx_lustre_file_system.lustre.id
  data_repository_path = "s3://${aws_s3_bucket.lustre.bucket}"
  file_system_path     = "/"
  s3 {
    auto_import_policy {
      events = ["NEW", "CHANGED", "DELETED"]
    }
    auto_export_policy {
      events = ["NEW", "CHANGED", "DELETED"]
    }
  }

  tags = {
    Name = join("-", [var.project_name, var.env, "lustre01-data-repo-assoc"])
  }
}
