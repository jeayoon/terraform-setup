output "acm_server_cert_arn" {
    value       = data.aws_acm_certificate.server_certificate.arn
    description = "AWS ACM Server Certifiacate ARN"
}

output "acm_client_cert_arn" {
    value       = data.aws_acm_certificate.client_certificate.arn
    description = "AWS ACM Client Certifiacate ARN"
}