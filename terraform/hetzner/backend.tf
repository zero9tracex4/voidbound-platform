terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    storage_account_name = "stvoidboundtf791a86"
    container_name       = "tfstate"
    key                  = "voidbound-platform/hetzner.tfstate"
  }
}
