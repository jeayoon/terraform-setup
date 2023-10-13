output "ecr_repo_url" {
  description = "ECR repository url"
  value       = try(aws_ecr_repository.main.repository_url, "")
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = try(aws_lb.main.dns_name, "")
}
