output "ip_publica" {
 value = azurerm_public_ip.pip.ip_address
}
output "url_app" {
 value = "http://${azurerm_public_ip.pip.ip_address}"
}
output "registro" {
 value = azurerm_container_registry.acr.login_server
}
