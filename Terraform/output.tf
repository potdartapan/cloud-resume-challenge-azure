output "website_url" {
  description = "The URL of the static website"
  value       = azurerm_storage_account.storage.primary_web_endpoint
}

output "function_url" {
  value = "https://${azurerm_windows_function_app.function_app.default_hostname}/api/GetVisitorCount"
}