# Terraform Module: AWS Lake Formation Table Filter

This Terraform module facilitates the automated deployment and management of AWS Lake Formation table filters and permissions. It's designed to handle both table and column-level granularity, providing flexibility for various data access scenarios. The module includes conditional logic to ensure resources are created only when necessary, and integrates an external module for consistent resource labeling.

### Features
- **Automated Lake Formation Permissions Management**: Configures AWS Lake Formation permissions for specified tables, managing them throughout their lifecycle.
- **Conditional Resource Creation**: Allows enabling or disabling the creation of resources using the `enable` variable.
- **Column-Level Granularity**: Support for managing access at a column level for finer-grained control.
- **Tagging**: Integrates with a labeling module to apply consistent tags to resources.
- **IAM Role Handling**: Automatically assigns permissions to a specified IAM role ARN for consuming the filtered data.

### Module Usage

```hcl
module "lakeformation_table_filter" {
  source = "git::ssh://git@github.mpi-internal.com/datastrategy-mobile-de/terraform-aws-lakeformation-table-filter-deployment.git?ref=tags/0.0.1"

  enable         = true
  stage          = var.stage
  project        = var.project
  project_id     = var.project_id
  git_repository = var.git_repository

  filter_name      = "tf"
  database_name    = aws_glue_catalog_database.tf_delta_db.name
  table_name       = "delta_ad_search"
  excluded_columns = ["head__app", "head__id"]

  consumer_iam_role_arn = module.athena_consume_lambda.aws_lambda_function_role_arn

  depends_on = [aws_lakeformation_data_lake_settings.admin_settings]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lake_formation_filter_labels"></a> [lake\_formation\_filter\_labels](#module\_lake\_formation\_filter\_labels) | git::ssh://git@github.mpi-internal.com/datastrategy-mobile-de/terraform-aws-label-deployment.git?ref=tags/0.0.1 |  |

## Resources

| Name | Type |
|------|------|
| [aws_lakeformation_permissions.filter_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_permissions) | resource |
| [aws_lakeformation_data_cells_filter.filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_data_cells_filter) | resource |
| [data.aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Whether to create the stack in this module or not. | `bool` | `true` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage of the Stack (dev/pre/prd) | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID used for billing | `string` | `"Not Set"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Instance specific Tags | `map(string)` | `{}` | no |
| <a name="input_git_repository"></a> [git\_repository](#input\_git\_repository) | Repository where the infrastructure was deployed from. | `string` | n/a | yes |
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Name of the filter | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the database | `string` | n/a | yes |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | Name of the table | `string` | n/a | yes |
| <a name="input_consumer_iam_role_arn"></a> [consumer\_iam\_role\_arn](#input\_consumer\_iam\_role\_arn) | A valid IAM role ARN for default table permissions | `string` | n/a | yes |
| <a name="input_excluded_columns"></a> [excluded\_columns](#input\_excluded\_columns) | List of columns to be excluded from the filter | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_filter_name"></a> [filter\_name](#output\_filter\_name) | The name of the filter |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the database |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | The name of the table |
| <a name="output_filter_permissions"></a> [filter\_permissions](#output\_filter\_permissions) | The Lake Formation filter permissions resource IDs |

<!-- END_TF_DOCS -->
```