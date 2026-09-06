output "resource_group_name" {
  value = data.azurerm_resource_group.voidbound_dev.name
}

output "resource_group_location" {
  value = data.azurerm_resource_group.voidbound_dev.location
}

output "resource_group_tags" {
  value = data.azurerm_resource_group.voidbound_dev.tags
}
