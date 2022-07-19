// Create the ECR repository
resource "aws_ecr_repository" "this" {
  name                 = local.var_name
  image_tag_mutability = local.var_mutable == true ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    // This ternary looks unnecessary, but the variable could be null
    scan_on_push = local.var_scan_on_push == true ? true : false
  }

  encryption_configuration {
    encryption_type = local.var_kms_key_id != null ? "KMS" : "AES256"
    kms_key         = local.var_kms_key_id
  }

  tags = local.var_tags
}

data "aws_ecr_authorization_token" "this" {
  count = local.var_generate_authorization_token == true ? 1 : 0
}

resource "aws_ecr_repository_policy" "this" {
  count      = local.var_create_repository_policy == true ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = local.repository_policy
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = local.var_create_lifecycle_policy == true ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = local.lifecycle_policy
}
