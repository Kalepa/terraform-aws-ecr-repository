variable "name" {
  description = "The name of the ECR repository."
  type        = string
  validation {
    condition     = var.name != null
    error_message = "The `name` input variable cannot be `null`."
  }
  nullable = false
}

variable "mutable" {
  description = "Whether images in the repository should be mutable."
  type        = bool
  default     = false
  nullable    = false
}

variable "scan_on_push" {
  description = "Whether to scan images when they are pushed to the repository."
  type        = bool
  default     = false
  nullable    = false
}

variable "kms_key_id" {
  description = "The ID of the KMS key to use to encrypt images in the repository. If not provided, AES256 encryption with AWS-managed keys will be used."
  type        = string
  default     = null
}

variable "generate_authorization_token" {
  description = "Whether to generate an authorization token for logging into the repository. NOTE: the value will change on each plan and/or apply."
  type        = bool
  default     = false
  nullable    = false
}

variable "create_repository_policy" {
  description = "Whether to apply an access policy to the repository. If this is set to `true`, then the `repository_policy` variable must also be provided."
  type        = bool
  default     = false
  nullable    = false
}

variable "repository_policy" {
  description = "The optional access policy to apply to the repository. It can be a JSON-formatted string, an `aws_iam_policy_document` data source object, or a JSON-encodable policy object. This variable only has an effect if the `create_repository_policy` is set to `true`."
  type        = any
  default     = null
  validation {
    // It must be null, OR JSON that can be decoded into something with keys (an object), OR something that has a json attribute which can be decoded into something with keys (an object), OR something that already has keys (an object)
    condition     = var.repository_policy == null || can(keys(jsondecode(var.repository_policy))) || can(keys(jsondecode(var.repository_policy.json))) || can(keys(var.repository_policy))
    error_message = "The `repository_policy` variable must be a JSON-formatted policy string, an `aws_iam_policy_document` data source object, or a JSON-encodable policy object."
  }
}

variable "create_lifecycle_policy" {
  description = "Whether to apply a lifecycle policy to the repository. If this is set to `true`, then the `lifecycle_policy` variable must also be provided."
  type        = bool
  default     = false
  nullable    = false
}

variable "lifecycle_policy" {
  description = "The optional JSON-formatted or JSON-encodable lifecycle policy to apply to the repository. This variable only has an effect if the `create_lifecycle_policy` is set to `true`."
  type        = any
  default     = null
  validation {
    // It must be null, OR JSON that can be decoded into something with keys (an object), OR something that already has keys (an object)
    condition     = var.lifecycle_policy == null || can(keys(jsondecode(var.lifecycle_policy))) || can(keys(var.lifecycle_policy))
    error_message = "The `lifecycle_policy` variable must be a JSON-formatted policy string or a JSON-encodable policy object."
  }
}

variable "include_registry_authorization_in_push_policy" {
  description = "Whether to include permission to get an authorization token for ECR in the push policy."
  type        = bool
  default     = true
  nullable    = false
}

variable "include_registry_authorization_in_pull_policy" {
  description = "Whether to include permission to get an authorization token for ECR in the pull policy."
  type        = bool
  default     = true
  nullable    = false
}

variable "create_policies" {
  description = "Whether to create IAM policies for pushing and pulling from the registry."
  type        = bool
  default     = false
  nullable    = false
}

variable "force_delete" {
  description = "If `true`, will delete the repository upon destroy even if it contains images."
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to all resources created in this module."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "region" {
  description = "The AWS region. If not provided, will be looked up via data source."
  type        = string
  default     = null
}
