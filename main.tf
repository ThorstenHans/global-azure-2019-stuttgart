provider "azurerm" {}

locals {
    default_tags = {
        environment = "${var.environment}"
        author = "${var.author}"
    }
  all_tags = "${merge(local.default_tags, var.custom_tags)}"
}

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "rggab" {
  name     = "gab-stuttgart-${var.environment}"
  location = "westeurope"
  tags = "${local.all_tags}"
}

resource "azurerm_app_service_plan" "asp_gab" {
  name                = "asp-gab-${random_integer.suffix.result}"
  location            = "${azurerm_resource_group.rggab.location}"
  resource_group_name = "${azurerm_resource_group.rggab.name}"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
  tags = "${local.all_tags}"
}

resource "azurerm_app_service" "as_gab" {
  name                = "as-gab-${random_integer.suffix.result}"
  location            = "${azurerm_resource_group.rggab.location}"
  resource_group_name = "${azurerm_resource_group.rggab.name}"
  app_service_plan_id = "${azurerm_app_service_plan.asp_gab.id}"

  app_settings {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|nginx:alpine"
  }
  tags = "${local.all_tags}"
}
