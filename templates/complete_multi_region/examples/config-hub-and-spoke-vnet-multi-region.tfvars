# This file contains templated variables to avoid repeating the same hard-coded values.
# Templated variables are denoted by the dollar-dollar curly braces token (e.g. $${starter_location_01}). The following details each templated variable that you can use:
# `starter_location_01`: This the primary an Azure location sourced from the `starter_locations` variable. This can be used to set the location of resources.
# `starter_location_02` to `starter_location_10`: These are the secondary Azure locations sourced from the `starter_locations` variable. This can be used to set the location of resources.
# `starter_location_01_availability_zones` to `starter_location_10_availability_zones`: These are the availability zones for the Azure locations sourced from the `starter_locations` variable. This can be used to set the availability zones of resources.
# `starter_location_01_virtual_network_gateway_sku_express_route` to `starter_location_10_virtual_network_gateway_sku_express_route`: These are the default SKUs for the Express Route virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
# `starter_location_01_virtual_network_gateway_sku_vpn` to `starter_location_10_virtual_network_gateway_sku_vpn`: These are the default SKUs for the VPN virtual network gateways based on the Azure locations sourced from the `starter_locations` variable. This can be used to set the SKU of the virtual network gateways.
# `root_parent_management_group_id`: This is the id of the management group that the ALZ hierarchy will be nested under.
# `subscription_id_identity`: The subscription ID of the subscription to deploy the identity resources to, sourced from the variable `subscription_id_identity`.
# `subscription_id_connectivity`: The subscription ID of the subscription to deploy the connectivity resources to, sourced from the variable `subscription_id_connectivity`.
# `subscription_id_management`: The subscription ID of the subscription to deploy the management resources to, sourced from the variable `subscription_id_management`.

management_use_avm = false
management_settings_es = {
  default_location              = "$${starter_location_01}"
  root_parent_id                = "$${root_parent_management_group_id}"
  root_id                       = "alz"
  root_name                     = "Azure-Landing-Zones"
  subscription_id_connectivity  = "$${subscription_id_connectivity}"
  subscription_id_identity      = "$${subscription_id_identity}"
  subscription_id_management    = "$${subscription_id_management}"
  deploy_connectivity_resources = false
  deploy_management_resources   = true
  configure_connectivity_resources = {
    settings = {
      dns = {
        config = {
          location = "$${starter_location_01}"
        }
      }
      ddos_protection_plan = {
        config = {
          location = "$${starter_location_01}"
        }
      }
    }
    advanced = {
      custom_settings_by_resource_type = {
        azurerm_resource_group = {
          dns = {
            ("$${starter_location_01}") = {
              name = "rg-hub-dns-$${starter_location_01}"
            }
          }
          ddos = {
            ("$${starter_location_01}") = {
              name = "rg-hub-ddos-$${starter_location_01}"
            }
          }
        }
        azurerm_network_ddos_protection_plan = {
          ddos = {
            ("$${starter_location_01}") = {
              name = "ddos-hub-$${starter_location_01}"
            }
          }
        }
      }
    }
  }
  configure_management_resources = {
    location = "$${starter_location_01}"
    advanced = {
      asc_export_resource_group_name = "rg-management-asc-export-$${starter_location_01}"
      custom_settings_by_resource_type = {
        azurerm_resource_group = {
          management = {
            name = "rg-management-$${starter_location_01}"
          }
        }
      }
      azurerm_log_analytics_workspace = {
        management = {
          name = "law-management-$${starter_location_01}"
        }
      }
      azurerm_automation_account = {
        management = {
          name = "aa-management-$${starter_location_01}"
        }
      }
    }
  }
}

connectivity_type = "hub_and_spoke_vnet"

connectivity_resource_groups = {
  ddos = {
    name     = "rg-hub-ddos-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
  vnet_primary = {
    name     = "rg-hub-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
  vnet_secondary = {
    name     = "rg-hub-$${starter_location_02}"
    location = "$${starter_location_02}"
  }
  dns = {
    name     = "rg-hub-dns-$${starter_location_01}"
    location = "$${starter_location_01}"
  }
}

hub_and_spoke_vnet_settings = {
  ddos_protection_plan = {
    name                = "ddos-hub-$${starter_location_01}"
    resource_group_name = "rg-hub-ddos-$${starter_location_01}"
    location            = "$${starter_location_01}"
  }
}

hub_and_spoke_vnet_virtual_networks = {
  primary = {
    hub_virtual_network = {
      name                            = "vnet-hub-$${starter_location_01}"
      resource_group_name             = "rg-hub-$${starter_location_01}"
      resource_group_creation_enabled = false
      location                        = "$${starter_location_01}"
      address_space                   = ["10.0.0.0/16"]
      subnets = {
        virtual_network_gateway = {
          name                         = "GatewaySubnet"
          address_prefixes             = ["10.0.1.0/24"]
          assign_generated_route_table = false
        }
      }
      firewall = {
        subnet_address_prefix = "10.0.0.0/24"
        name                  = "fw-hub-$${starter_location_01}"
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        zones                 = "$${starter_location_01_availability_zones}"
        default_ip_configuration = {
          public_ip_config = {
            name       = "pip-fw-hub-$${starter_location_01}"
            zones      = "$${starter_location_01_availability_zones}"
            ip_version = "IPv4"
          }
        }
        firewall_policy = {
          name = "fwp-hub-$${starter_location_01}"
          dns = {
            proxy_enabled = true
          }
        }
      }
    }
    virtual_network_gateways = {
      express_route = {
        location = "$${starter_location_01}"
        name     = "vgw-hub-expressroute-$${starter_location_01}"
        type     = "ExpressRoute"
        sku      = "$${starter_location_01_virtual_network_gateway_sku_express_route}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-expressroute-$${starter_location_01}"
            public_ip = {
              name  = "pip-vgw-hub-expressroute-$${starter_location_01}"
              zones = "$${starter_location_01_availability_zones}"
            }
          }
        }
      }
      vpn = {
        location = "$${starter_location_01}"
        name     = "vgw-hub-vpn-$${starter_location_01}"
        type     = "Vpn"
        sku      = "$${starter_location_01_virtual_network_gateway_sku_vpn}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-vpn-$${starter_location_01}"
            public_ip = {
              name  = "pip-vgw-hub-vpn-$${starter_location_01}"
              zones = "$${starter_location_01_availability_zones}"
            }
          }
        }
      }
    }
    private_dns_zones = {
      resource_group_name = "rg-hub-dns-$${starter_location_01}"
      is_primary          = true
    }
  }
  secondary = {
    hub_virtual_network = {
      name                            = "vnet-hub-$${starter_location_02}"
      resource_group_name             = "rg-hub-$${starter_location_02}"
      resource_group_creation_enabled = false
      location                        = "$${starter_location_02}"
      address_space                   = ["10.1.0.0/16"]
      subnets = {
        virtual_network_gateway = {
          name                         = "GatewaySubnet"
          address_prefixes             = ["10.1.1.0/24"]
          assign_generated_route_table = false
        }
      }
      firewall = {
        subnet_address_prefix = "10.1.0.0/24"
        name                  = "fw-hub-$${starter_location_02}"
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        zones                 = "$${starter_location_02_availability_zones}"
        default_ip_configuration = {
          public_ip_config = {
            name       = "pip-fw-hub-$${starter_location_02}"
            zones      = "$${starter_location_02_availability_zones}"
            ip_version = "IPv4"
          }
        }
        firewall_policy = {
          name = "fwp-hub-$${starter_location_01}"
          dns = {
            proxy_enabled = true
          }
        }
      }
    }
    virtual_network_gateways = {
      express_route = {
        location = "$${starter_location_02}"
        name     = "vgw-hub-expressroute-$${starter_location_02}"
        type     = "ExpressRoute"
        sku      = "$${starter_location_02_virtual_network_gateway_sku_express_route}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-expressroute-$${starter_location_02}"
            public_ip = {
              name  = "pip-vgw-hub-expressroute-$${starter_location_02}"
              zones = "$${starter_location_02_availability_zones}"
            }
          }
        }
      }
      vpn = {
        location = "$${starter_location_02}"
        name     = "vgw-hub-vpn-$${starter_location_02}"
        type     = "Vpn"
        sku      = "$${starter_location_02_virtual_network_gateway_sku_vpn}"
        ip_configurations = {
          default = {
            name = "ipconfig-vgw-hub-vpn-$${starter_location_02}"
            public_ip = {
              name  = "pip-vgw-hub-vpn-$${starter_location_02}"
              zones = "$${starter_location_02_availability_zones}"
            }
          }
        }
      }
    }
    private_dns_zones = {
      resource_group_name = "rg-hub-dns-$${starter_location_01}"
      is_primary          = false
    }
  }
}
