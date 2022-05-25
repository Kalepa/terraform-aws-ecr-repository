// Create the ECR repository
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.mutable == true ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    // This ternary looks unnecessary, but the variable could be null
    scan_on_push = var.scan_on_push == true ? true : false
  }

  encryption_configuration {
    encryption_type = var.kms_key_id != null ? "KMS" : "AES256"
    kms_key         = var.kms_key_id
  }

  tags = var.tags
}

data "aws_ecr_authorization_token" "this" {
  count = var.generate_authorization_token == true ? 1 : 0
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.create_repository_policy == true ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = local.repository_policy
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.create_lifecycle_policy == true ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = local.lifecycle_policy
}
