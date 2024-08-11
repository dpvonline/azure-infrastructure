resource "azurerm_resource_group" "infra" {
  name     = var.INFRA_NAME
  location = var.REGION
}
