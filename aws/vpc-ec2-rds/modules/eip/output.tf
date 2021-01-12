output "ec2_eip_id" {
    value       = aws_eip.ec2.id 
    description = "EC2 eip"
}