data "aws_region" "current" {}

locals {
  // Calculate the repository and lifecycle policies based on the type of input variable
  repository_policy = var.repository_policy == null ? null : (
    can(keys(jsondecode(var.repository_policy))) ? var.repository_policy : (
      can(keys(jsondecode(var.repository_policy.json))) ? var.repository_policy.json : (
        jsonencode(var.repository_policy)
      )
    )
  )

  lifecycle_policy = var.lifecycle_policy == null ? null : (
    can(keys(jsondecode(var.lifecycle_policy))) ? var.lifecycle_policy : (
      jsonencode(var.repository_policy)
    )
  )

  // IAM actions needed for pulling images from the repository
  pull_actions = [
    "ecr:BatchGetImage",
    "ecr:GetDownloadUrlForLayer",
  ]

  // IAM actions needed for pushing images to the repository
  push_actions = [
    "ecr:PutImage",
    "ecr:BatchGetImage",
    "ecr:InitiateLayerUpload",
    "ecr:UploadLayerPart",
    "ecr:CompleteLayerUpload",
    "ecr:BatchCheckLayerAvailability",
  ]
}
