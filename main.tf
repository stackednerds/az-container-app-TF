#Provider Code
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#Creating RG
resource "azurerm_resource_group" "my_rg" {
  name     = var.rg_name
  location = var.rg_location
}

#AZ Container App Log Analytics
resource "azurerm_log_analytics_workspace" "my_log" {
  name                = var.log_name
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

#Az App Env
resource "azurerm_container_app_environment" "my_appenv" {
  name                       = var.app_env
  location                   = azurerm_resource_group.my_rg.location
  resource_group_name        = azurerm_resource_group.my_rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.my_log.id
}

#Az Container App
resource "azurerm_container_app" "my_azcontapp" {
  name                         = var.cont_app
  container_app_environment_id = azurerm_container_app_environment.my_appenv.id
  resource_group_name          = azurerm_resource_group.my_rg.name
  revision_mode                = "Single"

  ingress {
    external_enabled = true
    target_port      = 8000  
  }

  template {
    container {
      name   = var.cont_app
      image  = var.image_name
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}
