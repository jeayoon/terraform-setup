output "vpc_endpoint_s3_id" {
    value       = aws_vpc_endpoint.s3.id
    description = "VPC Endpoint S3 id"
}