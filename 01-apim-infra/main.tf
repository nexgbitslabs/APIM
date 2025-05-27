# resource "random_pet" "rg_name" {
#   prefix = var.resource_group_name_prefix
# }

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location_name
}

# resource "random_string" "azurerm_api_management_name" {
#   length  = 13
#   lower   = true
#   numeric = false
#   special = false
#   upper   = false
# }

resource "azurerm_api_management" "api" {
  name                = var.api_name
  location            = var.location_name
  resource_group_name = var.rg_name
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  sku_name            = "${var.sku}_${var.sku_count}"
}


# 2. Storage Account (required for Function App)
resource "azurerm_storage_account" "storage" {
  name                     = "funcappstorcons001"
  resource_group_name      = var.rg_name
  location                 = var.location_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# 3. App Service Plan (Consumption)
resource "azurerm_app_service_plan" "plan" {
  name                = "functionapp-csp-plan"
  location            = var.location_name
  resource_group_name = var.rg_name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
resource "azurerm_function_app" "function" {
  name                       = "my-csharp-funcapp"
  location                   = var.location_name
  resource_group_name        = var.rg_name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~4"
  os_type                    = "linux"

  site_config {
    dotnet_framework_version = "v6.0"
  }

  identity {
    type = "SystemAssigned"
  }
}