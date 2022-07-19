// A policy document that ECS to get images from ECR
data "aws_iam_policy_document" "ecr_pull" {
  dynamic "statement" {
    // This ternary looks odd, but it's designed to default to adding this statement if the variable is `null`.
    for_each = local.var_include_registry_authorization_in_pull_policy != false ? [1] : []
    content {
      actions = [
        "ecr:GetAuthorizationToken",
      ]
      resources = [
        "*"
      ]
    }
  }
  statement {
    actions = local.pull_actions
    resources = [
      aws_ecr_repository.this.arn
    ]
  }
}

resource "aws_iam_policy" "ecr_pull" {
  count  = local.var_create_policies == true ? 1 : 0
  name   = "ecr-${local.var_name}"
  path   = "/ecr/"
  policy = data.aws_iam_policy_document.ecr_pull.json
  tags   = local.var_tags
}

data "aws_iam_policy_document" "ecr_push" {
  dynamic "statement" {
    for_each = local.var_include_registry_authorization_in_push_policy != false ? [1] : []
    content {
      actions = [
        "ecr:GetAuthorizationToken",
      ]
      resources = [
        "*"
      ]
    }
  }
  statement {
    actions = local.push_actions
    resources = [
      aws_ecr_repository.this.arn
    ]
  }
}

resource "aws_iam_policy" "ecr_push" {
  count  = local.var_create_policies == true ? 1 : 0
  name   = "${local.var_name}-push"
  path   = "/ecr/"
  policy = data.aws_iam_policy_document.ecr_push.json
  tags   = local.var_tags
}
