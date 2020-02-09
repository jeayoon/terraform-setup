output "ec2_sg_id" {
    value       = aws_security_group.ec2.id
    description = "EC2 Security Group ID"
}
output "rds_sg_id" {
    value       = aws_security_group.rds.id
    description = "RDS Security Group ID"
}