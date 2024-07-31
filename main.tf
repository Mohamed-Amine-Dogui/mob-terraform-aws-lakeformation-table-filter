locals {
  project_id = var.project_id == "" ? var.project : var.project_id
}

data "aws_caller_identity" "current" {}

module "lake_formation_filter_labels" {
  source          = "git::ssh://git@github.mpi-internal.com/datastrategy-mobile-de/terraform-aws-label-deployment.git?ref=tags/0.0.1"
  stage           = var.stage
  project         = var.project
  project_id      = local.project_id
  name            = var.filter_name
  resource_group  = ""
  resources       = ["filter"]
  additional_tags = var.tags
  max_length      = 64
  git_repository  = var.git_repository
}


resource "aws_lakeformation_data_cells_filter" "filter" {
  count = var.enable ? 1 : 0

  table_data {
    database_name    = var.database_name
    name             =  "${module.lake_formation_filter_labels.resource["filter"]["id"]}"
    table_catalog_id = data.aws_caller_identity.current.account_id
    table_name       = var.table_name

    column_wildcard {
      excluded_column_names = var.excluded_columns
    }

    row_filter {
      all_rows_wildcard {}
    }

  }
}

resource "aws_lakeformation_permissions" "filter_permissions" {
  count = var.enable ? 1 : 0

  principal = var.consumer_iam_role_arn

  permissions = ["SELECT", "DESCRIBE"]
  permissions_with_grant_option  = ["SELECT", "DESCRIBE"]

  data_cells_filter {
    database_name = var.database_name
    name = "${module.lake_formation_filter_labels.resource["filter"]["id"]}"
    table_catalog_id = data.aws_caller_identity.current.account_id
    table_name = var.table_name
  }
  depends_on = [aws_lakeformation_data_cells_filter.filter]
}
