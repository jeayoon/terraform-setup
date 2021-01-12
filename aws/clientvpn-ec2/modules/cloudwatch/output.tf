output "client_vpn_log_group_name" {
    value       = aws_cloudwatch_log_group.client_vpn_log_group.name 
    description = "Client VPN Cloud watch log group name"
}

output "client_vpn_log_stream_name" {
    value       = aws_cloudwatch_log_stream.client_vpn_log_stream.name 
    description = "Client VPN Cloud watch log stream name"
}
