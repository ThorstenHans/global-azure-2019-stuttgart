output "website_url" {
  value = "${azurerm_app_service.as_gab.default_site_hostname}"
}
