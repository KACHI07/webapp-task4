 output "url" {
  value = azurerm_app_service.as[*].default_site_hostname
}
