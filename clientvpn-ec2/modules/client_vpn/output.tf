output "client_vpn_sg" {
    value       = aws_ec2_client_vpn_network_association.vpn.security_groups
    description = "Client VPN Security Groups"
}
