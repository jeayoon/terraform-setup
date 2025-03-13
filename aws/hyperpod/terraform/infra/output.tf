output "fsx_mount_name" {
  value = aws_fsx_lustre_file_system.lustre.mount_name
}

output "fsx_dns_name" {
  value = aws_fsx_lustre_file_system.lustre.dns_name
}

output "efa_sg_id" {
  value = aws_security_group.efa_sg.id
}

output "primary_private_subnet_id" {
  value = aws_subnet.private01.id
}

output "second_private_subnet_id" {
  value = aws_subnet.private02.id
}

output "sagemaker_execution_role_arn" {
  value = aws_iam_role.sagemaker_execution_role.arn
}

output "s3_lifecycle_bucket_Uri" {
  value = "s3://${aws_s3_object.lifecycle_scripts.bucket}/${aws_s3_object.lifecycle_scripts.key}"
}
