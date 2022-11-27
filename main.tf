terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  
}

resource "azurerm_resource_group" "k8s" {
  name     = "k8s-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "k8s" {
  name                = "k8s-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
}

resource "azurerm_subnet" "k8s" {
  name                 = "k8s-subnet"
  virtual_network_name = azurerm_virtual_network.k8s.name
  resource_group_name  = azurerm_resource_group.k8s.name
  address_prefixes     = ["10.1.0.0/22"]
}
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "k8scluster"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "k8scluster"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.k8s.id
  }
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.k8s.id
}

