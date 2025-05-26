# resource "random_pet" "rg_name" {
#   prefix = var.resource_group_name_prefix
# }

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location_name
}

resource "random_string" "azurerm_api_management_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_api_management" "api" {
  name                = "apiservice${random_string.azurerm_api_management_name.result}"
  location            = var.location_name
  resource_group_name = var.rg_name
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  sku_name            = "${var.sku}_${var.sku_count}"
}