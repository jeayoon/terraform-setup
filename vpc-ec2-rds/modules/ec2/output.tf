output "ec2_instance_id" {
    value       = aws_instance.main.id 
    description = "EC2 Instance ID"
}
