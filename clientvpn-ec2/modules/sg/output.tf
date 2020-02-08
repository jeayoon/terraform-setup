output "ec2_sg_id" {
    value       = aws_security_group.ec2.id
    description = "EC2 Security Group ID"
}
output "client_vpn_sg_id" {
    value       = aws_security_group.client_vpn.id
    description = "EC2 Security Group ID"
}