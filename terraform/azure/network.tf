resource "azurerm_virtual_network" "voidbound_dev" {
  name                = "vnet-voidbound-dev"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.voidbound_dev.name
  address_space       = ["10.20.0.0/16"]
}
resource "azurerm_subnet" "app" {
  name                            = "snet-app"
  resource_group_name             = azurerm_resource_group.voidbound_dev.name
  virtual_network_name            = azurerm_virtual_network.voidbound_dev.name
  address_prefixes                = ["10.20.1.0/24"]
  default_outbound_access_enabled = false
}
resource "azurerm_network_security_group" "app" {
  name                = "nsg-snet-app"
  location            = "swedencentral"
  resource_group_name = azurerm_resource_group.voidbound_dev.name

  security_rule {
    name                       = "Allow-SSH-From-Home"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "149.107.52.42/32"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}
