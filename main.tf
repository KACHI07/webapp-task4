terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.31.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
  }

}
resource "azurerm_resource_group" "rg" {
  name     = "WebAppXs-rg"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "asp" {
  name                = "WebAppXs-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  kind = "linux"
  reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }

   tags = {
    creator = "Babayega"

  }
}

resource "azurerm_app_service" "as" {

   name               = "WebAppXs-as"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

   site_config {
    linux_fx_version = "DOCKER|nginx:latest"
  }



  tags = {
    image = "nginx"

  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }

}


resource "azurerm_app_service_slot" "ass" {
  name                = "WebAppXs-dev"
  app_service_name    = azurerm_app_service.as.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
       linux_fx_version = "DOCKER|wordpress:latest"
  }

  tags = {
    image = "wordpress"
 }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_app_service_slot" "ass1" {
  name                = "WebAppXs-prod"
  app_service_name    = azurerm_app_service.as.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
       linux_fx_version = "DOCKER|mcr.microsoft.com/dotnet/samples:aspnetapp"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}



