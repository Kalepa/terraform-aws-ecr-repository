# Terraform AWS ECR Repository

This module creates an ECR repository and related resources, including (each is optional):
- Repository policy
- Lifecycle policy
- IAM policies (push and pull)

It is primarily designed as a convenient way to get/manage IAM policy documents (and optionally, IAM policy resources) with appropriate permissions for the created repository.