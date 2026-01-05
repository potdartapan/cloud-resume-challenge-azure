output "function_url" {
  # Change 'windows' to 'linux' to match your resource declaration
  value = "https://${azurerm_linux_function_app.function_app.default_hostname}/api/GetVisitorCount"
}

output "storage_static_website_url" {
  value = azurerm_storage_account.storage.primary_web_endpoint
}

output "grafana_url" {
  value = azurerm_dashboard_grafana.resume_dash.endpoint
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.resume_logs.workspace_id
}
