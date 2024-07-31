# variables.tf

variable "enable" {
  description = "Whether to create the stack in this module or not."
  type        = bool
  default     = true
}

variable "stage" {
  description = "Stage of the Stack (dev/pre/prd)"
}

variable "project" {}

variable "project_id" {
  type        = string
  default     = "Not Set"
  description = "ID used for billing"
}

variable "tags" {
  description = "Instance specific Tags"
  type        = map(string)
  default     = {}
}

variable "git_repository" {
  type        = string
  description = "Repository where the infrastructure was deployed from."
}

variable "filter_name" {
  description = "Name of the filter"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "table_name" {
  description = "Name of the table"
  type        = string
}

variable "consumer_iam_role_arn" {
  description = "A valid IAM role ARN for default table permissions"
  type        = string
}

variable "excluded_columns" {
  description = "List of columns to be excluded from the filter"
  type        = list(string)
  default     = []
}