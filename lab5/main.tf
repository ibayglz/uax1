locals {
  prefijo = "lab5-${var.alias}"
  etiquetas = {
    curso  = "isn"
    lab    = "lab5"
    alumno = var.alias
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.prefijo}"
  location = var.location
  tags     = local.etiquetas
}
