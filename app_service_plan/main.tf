resource "azurerm_service_plan" "service_plan" {
  name                = var.app_service_plan_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku_name            = var.app_service_plan_sku_name
  os_type             = "Windows"
}
