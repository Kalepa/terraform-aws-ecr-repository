data "aws_region" "current" {}

locals {
  // Calculate the repository and lifecycle policies based on the type of input variable
  repository_policy = local.var_repository_policy == null ? null : (
    can(keys(jsondecode(local.var_repository_policy))) ? local.var_repository_policy : (
      can(keys(jsondecode(local.var_repository_policy.json))) ? local.var_repository_policy.json : (
        jsonencode(local.var_repository_policy)
      )
    )
  )

  lifecycle_policy = local.var_lifecycle_policy == null ? null : (
    can(keys(jsondecode(local.var_lifecycle_policy))) ? local.var_lifecycle_policy : (
      jsonencode(local.var_repository_policy)
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
