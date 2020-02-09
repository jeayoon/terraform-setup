output "app_subnet1_id" {
    value       = aws_subnet.app_subnet1.id
    description = "App Subnet1 ID"
}

output "db_subnet1_id" {
    value = aws_subnet.db_subnet1.id
    description = "DB Subnet1 ID"
}
}

output "db_subnet2_id" {
    value = aws_subnet.db_subnet2.id
    description = "DB Subnet2 ID"
}

