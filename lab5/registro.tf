resource "azurerm_container_registry" "acr" {
 name = "acr${var.alias}lab5"
 resource_group_name = azurerm_resource_group.rg.name
 tags = local.etiquetas
 location = azurerm_resource_group.rg.location
 sku = "Basic"
 admin_enabled = false
}
