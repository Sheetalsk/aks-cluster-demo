

// used for security identiy of the application. Eg.,
module "ServicePrincipal" {
    source = "./modules/ServicePrincipal"
    service_principal_name = var.service_principal_name

    depends_on = [ 
        azurerm_resource_group.rg 
    ]
}


// target environment eg. AWS, GCP or Azure
provider "azurerm" {
    skip_provider_registration = true //use Azure CLI mode
    features {}
  
}

resource "azurerm_resource_group" "rg" {
    name = var.rgname
    location = var.location
}

//role assignment to principal
resource "azurerm_role_assignment" "rolespn" {
  scope              = "/subscriptions/8b11d5a9-7d6e-417a-a42c-91e9038126b4"
  role_definition_name = "Contributor"
  principal_id       = module.ServicePrincipal.service_principal_object_id

  depends_on = [ module.ServicePrincipal ]
}

module "keyvault" {
    source = "./modules/keyvault"
    resource_group_name = var.rgname
    keyvault_location = var.location
    keyvault_name = var.keyvault_name
}

module "aks" {
    source = "./modules/aks"
    service_principal_name = var.service_principal_name
    client_id = module.ServicePrincipal.client_id
    client_secret = module.ServicePrincipal.client_secret
    location = var.location
    resource_group_name = var.rgname
  
}