output "nat_subnet_id" {
    value       = aws_subnet.nat_subnet.id
    description = "NAT Subnet ID"
}

output "app_subnet1_id" {
    value       = aws_subnet.app_subnet1.id
    description = "App Subnet1 ID"
}