resource "azurerm_virtual_network" "vnet" {
 name = "vnet-lab5"
 address_space = ["10.0.0.0/16"]
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 tags = local.etiquetas
}
resource "azurerm_subnet" "web" {
 name = "snet-web"
 resource_group_name = azurerm_resource_group.rg.name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefixes = ["10.0.1.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
 name = "nsg-web"
 location = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 tags = local.etiquetas
 security_rule {
 name = "permitir-ssh-mi-ip"
 priority = 100
 direction = "Inbound"
 access = "Allow"
 protocol = "Tcp"
 source_port_range = "*"
 destination_port_range = "22"
 source_address_prefix = var.mi_ip
 destination_address_prefix = "*"
 }
 security_rule {
 name = "permitir-http"
 priority = 110
 direction = "Inbound"
 access = "Allow"
 protocol = "Tcp"
 source_port_range = "*"
 destination_port_range = "80"
 source_address_prefix = "*"
 destination_address_prefix = "*"
 }
}
resource "azurerm_subnet_network_security_group_association" "web" {
 subnet_id = azurerm_subnet.web.id
 network_security_group_id = azurerm_network_security_group.nsg.id
}
