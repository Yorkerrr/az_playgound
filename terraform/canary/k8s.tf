resource "azurerm_resource_group" "k8s" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "k8s" {
  name                = "k8s-network"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  address_space       = ["172.20.0.0/16"]
}

resource "azurerm_subnet" "primary" {
  name                 = "primary"
  resource_group_name  = azurerm_resource_group.k8s.name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes     = ["172.20.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "primary" {
    name                = "primary"
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = "primary"
    sku_tier            = "Free"
    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2_v2"
        type            = "VirtualMachineScaleSets"
        vnet_subnet_id  = azurerm_subnet.primary.id
    }

    service_principal {
        client_id     = var.client_id
        client_secret = var.client_secret
    }

    addon_profile {
                oms_agent {
        enabled                    = false
        # log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
        }
    }
    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "azure"
        outbound_type  = "loadBalancer"
    }
    tags = {
        Environment = "Development"
    }
    auto_scaler_profile {
        balance_similar_node_groups = false
    }
    role_based_access_control {
        enabled = false
    }
}