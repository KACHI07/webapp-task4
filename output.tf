 output "url" {
  value = azurerm_app_service.as[*].default_site_hostname
}
 output "urldev" {
  value = azurerm_app_service_slot.ass[*].default_site_hostname
}
 output "urlprod" {
  value = azurerm_app_service_slot.ass1[*].default_site_hostname
}
