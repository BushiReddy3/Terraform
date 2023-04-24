data "azurerm_client_config" "current" {}

resource "azurerm_windows_function_app" "Func_windows_app" {
  for_each                    = var.apps
  name                        = each.value
  builtin_logging_enabled     = false
  client_certificate_mode     = "Required"
  functions_extension_version = "~4"
  https_only                  = true
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  service_plan_id             = azurerm_service_plan.service_plan.id
  storage_account_access_key  = length(regexall(local.api_filter, each.value)) > 0 ? var.storage_account_api.access_key : var.storage_account_jobs.access_key
  storage_account_name        = length(regexall(local.api_filter, each.value)) > 0 ? var.storage_account_api.name : var.storage_account_jobs.name
  virtual_network_subnet_id   = var.vnet_subnet_id_for_app

  identity {
    type = "SystemAssigned"
  }

  app_settings = length(regexall(local.api_filter, each.value)) > 0 ? (length(regexall("abc", each.value)) > 0 ? local.app_settings_for_abc_api : local.app_settings_for_xyz_api) : local.app_settings_for_jobs

  site_config {
    application_insights_connection_string = var.application_insights.conenction_string
    application_insights_key               = var.application_insights.key
    http2_enabled                          = true
    ftps_state                             = "FtpsOnly"
    scm_minimum_tls_version                = "1.2"
    vnet_route_all_enabled                 = true
    use_32_bit_worker                      = false
    always_on                              = true

    application_stack {
      dotnet_version = "v6.0"
    }

    ip_restriction {
      action      = "Allow"
      priority    = 1
      name        = "BlockAll"
      service_tag = null
      ip_address  = null

      headers = length(regexall(local.api_filter, each.value)) > 0 ? [{
        x_azure_fdid      = var.header_x_azure_fdid_for_api
        x_fd_health_probe = null
        x_forwarded_for   = null
        x_forwarded_host  = null
      }] : null
    }

    cors {
      allowed_origins = var.allowed_origins
    }
  }

  
  connection_string {
    name  = "SqlConnectionString"
    value = local.connection_strings_for_func_app
    type  = "SQLAzure"
  }


  lifecycle {
    ignore_changes = [
      #app_settings,
      connection_string,
      site_config["cors"],

      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]

    #prevent_destroy = true   
  }
}

resource "azurerm_windows_web_app" "WebApp" {
  name                      = var.windows_web_app_name
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  service_plan_id           = azurerm_service_plan.service_plan.id
  https_only                = true
  virtual_network_subnet_id = var.vnet_subnet_id_for_web

  identity {
    type = "SystemAssigned"
  }

  app_settings = local.app_settings_for_scheduler

  site_config {
    minimum_tls_version    = "1.2"
    vnet_route_all_enabled = true
    use_32_bit_worker      = false
    always_on              = true

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }

    dynamic "ip_restriction" {
      for_each = var.ip_addresses
      content {
        action     = "Allow"
        priority   = 1
        name       = ip_restriction.value["name"]
        ip_address = format("%s/%s", ip_restriction.value["ip_address"], "32")
      }
    }
  }

  lifecycle {
    ignore_changes = [
      #app_settings,
      connection_string
    ]

    #prevent_destroy = true   
  }
}

resource "null_resource" "command" {
  for_each = { for funcs in local.func_names : funcs.func_name => funcs if length(regexall(local.api_filter, funcs.func_name)) > 0 }
  provisioner "local-exec" {
    command = "az account set -s ${var.sp_subscription_id}"
  }

  depends_on = [
    azurerm_windows_function_app.Func_windows_app
  ]
}


resource "null_resource" "command1" {
  for_each = { for funcs in local.func_names : funcs.func_name => funcs if length(regexall(local.api_filter, funcs.func_name)) > 0 }
  provisioner "local-exec" {
    command = "az webapp auth update -g ${var.resource_group_name} --name ${each.value.func_name} --enabled true --unauthenticated-client-action RedirectToLoginPage --redirect-provider azureactivedirectory"
  }

  depends_on = [
    azurerm_windows_function_app.Func_windows_app,
    null_resource.command
  ]
}

resource "null_resource" "command2" {
  for_each = { for funcs in local.func_names : funcs.func_name => funcs if length(regexall(local.api_filter, funcs.func_name)) > 0 }
  provisioner "local-exec" {
    command = "az webapp auth microsoft update -g ${var.resource_group_name} --name ${each.value.func_name} --client-id ${var.client_id} --issuer ${var.issuer}"
  }

  depends_on = [
    azurerm_windows_function_app.Func_windows_app,
    null_resource.command,
    null_resource.command1
  ]
}

locals {
  func_names = flatten([
    for funcs in azurerm_windows_function_app.Func_windows_app : {
      func_name = funcs.name
    }
  ])
}
