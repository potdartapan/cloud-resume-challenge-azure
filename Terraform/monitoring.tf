resource "azurerm_log_analytics_workspace" "resume_logs" {
  name                = "law-cloud-resume"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "name" {
  name                = "insights-cloud-resume"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.resume_logs.id
  application_type    = "web"
}

resource "azurerm_monitor_diagnostic_setting" "storage_blog_logs" {
  name                       = "diag-blob-traffic"
  target_resource_id         = "${azurerm_storage_account.storage.id}/blobServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.resume_logs.id

  enabled_log { category_group = "alllogs" }
  metric { category = "AllMetrics" }
}

resource "azurerm_monitor_diagnostic_setting" "storage_table_logs" {
  name                       = "diag-table-traffic"
  target_resource_id         = "${azurerm_storage_account.storage.id}/tableServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.resume_logs.id

  enabled_log { category_group = "alllogs" }
  metric { category = "AllMetrics" }
}
resource "azurerm_dashboard_grafana" "resume_dash" {
  name                  = "grafana-cloud-resume"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  sku                   = "Essential"
  grafana_major_version = 11
  identity { type = "SystemAssigned" }
}

resource "azurerm_role_assignment" "grafana_monitor_reader" {
  scope                = azurerm_log_analytics_workspace.resume_logs.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.resume_dash.identity[0].principal_id
}