output "ec2_instance_role_name" {
    value       = aws_iam_role.ec2_instance_role.name
    description = "EC2 instance role name"
}