output "repository_url" {
  description = "Repository URL"
  value       = aws_ecr_repository.this.repository_url
}

output "test_output" {
  value = aws_ecr_repository.this.name
}
