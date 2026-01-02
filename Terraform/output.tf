output "function_url" {
  # Change 'windows' to 'linux' to match your resource declaration
  value = "https://${azurerm_linux_function_app.function_app.default_hostname}/api/GetVisitorCount"
}