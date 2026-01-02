resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name = var.storage_account_name

  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  public_network_access_enabled = true
  min_tls_version               = "TLS1_2"

  static_website {
    index_document     = "index.html"
   # error_404_document = "404.html"
  }
}

resource "azurerm_storage_table" "visitor_table" {
  name                 = "VisitorCount"
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_storage_table_entity" "count_row" {
  storage_table_id = azurerm_storage_table.visitor_table.id

  partition_key = "visitor_stats"
  row_key       = "1"

  entity = {
    count = "0"
  }
}

resource "azurerm_service_plan" "func_plan" {
  name                = "resume-functions-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux" 
  sku_name            = "Y1"     
}

resource "azurerm_linux_function_app" "function_app" {
  name                = "tf-clouf-resume-challenge-tp" # Must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.func_plan.id

  site_config {
    application_stack {
      # Choose the language you plan to write your counter in
      python_version = "3.11" 
      # OR: node_version = "20"
      # OR: dotnet_version = "8.0"
    }
    
    # Important: This allows your website to talk to your function
    cors {
      allowed_origins = [
        "https://${azurerm_storage_account.storage.primary_web_host}",
        "http://localhost:3000" # For local testing
      ]
    }
  }
  app_settings = {
    "TABLE_STORAGE_CONNECTION_STRING" = azurerm_storage_account.storage.primary_connection_string
  }
}