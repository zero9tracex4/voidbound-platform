resource "azurerm_resource_group" "voidbound_dev" {
  name     = "rg-voidbound-dev"
  location = "italynorth"

  tags = {
    environment = "dev"
    managed-by  = "terraform"
    project     = "voidbound-platform"
  }

  lifecycle {
    prevent_destroy = true
  }
}
