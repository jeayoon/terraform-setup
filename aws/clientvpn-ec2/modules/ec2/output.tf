output "ec2_instance_id" {
    value       = aws_instance.main.id 
    description = "EC2 Instance ID"
}

output "ec2_private_id" {
    value       = aws_instance.main.private_ip
    description = "EC2 Private ID"
}