locals {
  config_file_extension = replace(lower(element(local.config_file_split, length(local.config_file_split) - 1)), local.const_yml, local.const_yaml)
  config_file_name      = var.configuration_file_path == "" ? "config-hub-and-spoke-vnet.yaml" : basename(var.configuration_file_path)
  config_file_split     = split(".", local.config_file_name)
  const_yaml            = "yaml"
  const_yml             = "yml"

  is_yaml             = local.config_file_extension == local.const_yaml || local.config_file_extension == local.const_yml
  config_file_content = templatefile("${path.module}/${local.config_file_name}", local.config_template_file_variables)
  config = (local.is_yaml ?
    yamldecode(local.config_file_content) :
    jsondecode(local.config_file_content)
  )

  config_template_file_variables = {
    starter_location_01                    = var.starter_locations[0]
    starter_location_02                    = try(var.starter_locations[1], null)
    starter_location_03                    = try(var.starter_locations[2], null)
    starter_location_04                    = try(var.starter_locations[3], null)
    starter_location_05                    = try(var.starter_locations[4], null)
    starter_location_06                    = try(var.starter_locations[5], null)
    starter_location_07                    = try(var.starter_locations[6], null)
    starter_location_08                    = try(var.starter_locations[7], null)
    starter_location_09                    = try(var.starter_locations[8], null)
    starter_location_10                    = try(var.starter_locations[9], null)
    starter_location_01_availability_zones = jsonencode(local.regions[var.starter_locations[0]].zones)
    starter_location_02_availability_zones = jsonencode(try(local.regions[var.starter_locations[1]].zones, null))
    starter_location_03_availability_zones = jsonencode(try(local.regions[var.starter_locations[2]].zones, null))
    starter_location_04_availability_zones = jsonencode(try(local.regions[var.starter_locations[3]].zones, null))
    starter_location_05_availability_zones = jsonencode(try(local.regions[var.starter_locations[4]].zones, null))
    starter_location_06_availability_zones = jsonencode(try(local.regions[var.starter_locations[5]].zones, null))
    starter_location_07_availability_zones = jsonencode(try(local.regions[var.starter_locations[6]].zones, null))
    starter_location_08_availability_zones = jsonencode(try(local.regions[var.starter_locations[7]].zones, null))
    starter_location_09_availability_zones = jsonencode(try(local.regions[var.starter_locations[8]].zones, null))
    starter_location_10_availability_zones = jsonencode(try(local.regions[var.starter_locations[9]].zones, null))
    default_postfix                        = var.default_postfix
    root_parent_management_group_id        = var.root_parent_management_group_id == "" ? data.azurerm_client_config.current.tenant_id : var.root_parent_management_group_id
    subscription_id_connectivity           = var.subscription_id_connectivity
    subscription_id_identity               = var.subscription_id_identity
    subscription_id_management             = var.subscription_id_management
  }
}