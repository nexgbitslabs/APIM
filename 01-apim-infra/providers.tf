output "resource_group_name" {
  value = var.rg_name
}

output "api_management_service_name" {
  value = azurerm_api_management.api.name
}