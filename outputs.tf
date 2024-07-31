# output.tf

output "filter_name" {
  value = var.filter_name
}

output "database_name" {
  value = var.database_name
}

output "table_name" {
  value = var.table_name
}

output "filter_permissions" {
  description = "Lake Formation filter permissions"
  value       = aws_lakeformation_permissions.filter_permissions[*].id
}