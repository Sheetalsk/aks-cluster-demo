data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = var.cluster_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  depends_on = [azurerm_resource_group.rg]

  identity {
    type = "SystemAssigned"
  }
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_DS2_v2"
    zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
   } 
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
        key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "cluster_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id
}