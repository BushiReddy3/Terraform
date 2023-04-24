terraform {
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.23.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.29.0"
    }
  }
}

provider "azurerm" {

  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }

  storage_use_azuread = true
  subscription_id     = var.sp_subscription_id
  tenant_id           = var.sp_tenant_id
  client_id           = var.sp_client_id
  client_secret       = var.sp_client_secret
}

module "resource_group" {
  source                  = "./modules/resource_group"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "storage_account" {
  source                               = "./modules/storage_accounts"
  resource_group_name                  = module.resource_group.resource_group_name
  resource_group_location              = module.resource_group.resource_group_location
  storage_name_data                    = var.storage_name_data
  storage_name_log                     = var.storage_name_log
  account_tier                         = var.account_tier
  list_of_storage_data_container_names = var.list_of_storage_data_container_names
  storage_log_container_name           = var.storage_log_container_name
  container_private_access_type        = var.container_private_access_type
  container_blob_access_type           = var.container_blob_access_type
  subnet_id                            = [module.vnet.subnet_id_for_infra, module.vnet.subnet_id_for_app, module.vnet.subnet_id_for_web]
  ip_addresses                         = local.ip_addresses
  allowed_origins                      = var.list_of_allowed_origins
  storage_api_name                     = var.storage_api_name
  storage_job_name                     = var.storage_job_name
  depends_on = [
    module.resource_group,
    module.vnet
  ]
}

module "vnet" {
  source                              = "./modules/vnet"
  resource_group_name                 = module.resource_group.resource_group_name
  resource_group_location             = module.resource_group.resource_group_location
  virtual_network_name                = var.virtual_network_name
  virtual_network_security_group_name = var.virtual_network_security_group_name
  address_space                       = var.address_space
  subnets                             = var.subnets

  depends_on = [
    module.resource_group
  ]
}

module "sql_server" {
  source                             = "./modules/sql_server"
  sql_server_name                    = var.sql_server_name
  resource_group_name                = module.resource_group.resource_group_name
  resource_group_location            = module.resource_group.resource_group_location
  sql_server_version                 = var.sql_server_version
  administrator_login                = var.administrator_login
  administrator_login_password       = var.administrator_login_password
  sql_elasticpool_name               = var.sql_elasticpool_name
  sql_elasticpool_max_size_gb        = var.sql_elasticpool_max_size_gb
  sql_virtual_network_rule_name      = var.sql_virtual_network_rule_name
  subnet_id                          = module.vnet.subnet_id_for_db
  subnet_app_id                      = module.vnet.subnet_id_for_app
  subnet_web_id                      = module.vnet.subnet_id_for_web
  sql_server_db_database_name        = var.sql_server_db_database_name
  sql_server_scheduler_database_name = var.sql_server_scheduler_database_name
  sql_collation                      = var.sql_collation
  sql_database_max_size_gb           = var.sql_database_max_size_gb
  sql_elasticpool_sku                = var.sql_elasticpool_sku
  sql_server_firewall_ips            = var.sql_server_firewall_ips
  sql_aad_admin                      = var.sql_aad_admin
  per_database_settings_max_capacity = var.per_database_settings_max_capacity
  depends_on = [
    module.resource_group,
    module.vnet
  ]

}

module "Key_Vault" {
  source                     = "./modules/key_vault"
  key_vault_name             = var.key_vault_name
  key_vault_name_cred        = var.key_vault_name_cred
  resource_group_name        = module.resource_group.resource_group_name
  resource_group_location    = module.resource_group.resource_group_location
  subnet_id                  = module.vnet.subnet_id_for_infra
  subnet_app_id              = module.vnet.subnet_id_for_app
  subnet_web_id              = module.vnet.subnet_id_for_web
  ip_addresses               = local.ip_addresses
  sp_object_id               = var.sp_object_id
  cg_azure_geoview_object_id = var.sql_aad_admin.object_id
}

module "application_insights" {
  source                                 = "./modules/application_insights"
  log_analytics_workspace_name           = var.log_analytics_workspace_name
  application_insights_name              = var.application_insights_name
  resource_group_name                    = module.resource_group.resource_group_name
  resource_group_location                = module.resource_group.resource_group_location
  application_insights_sku               = var.application_insights_sku
  application_insights_retention_in_days = var.application_insights_retention_in_days
  application_insights_application_type  = var.application_insights_application_type
}

module "app_service_plan" {
  source                      = "./modules/app_service_plan"
  app_service_plan_name       = var.app_service_plan.name
  resource_group_location     = module.resource_group.resource_group_location
  resource_group_name         = module.resource_group.resource_group_name
  windows_web_app_name        = var.app_service_plan_windows_web_app_name
  key_vault_id                = module.Key_Vault.key_vault_id
  apps                        = var.app_service_plan.apps
  vnet_subnet_id_for_web      = module.vnet.subnet_id_for_web
  vnet_subnet_id_for_app      = module.vnet.subnet_id_for_app
  app_service_plan_sku_name   = var.app_service_plan_sku_name
  is_dev_env                  = var.is_dev_env
  header_x_azure_fdid_for_api = var.header_x_azure_fdid_for_api
  ip_addresses                = local.ip_addresses
  allowed_origins             = var.list_of_allowed_origins
  client_id                   = var.client_id
  issuer                      = var.issuer
  sp_subscription_id          = var.sp_subscription_id

  storage_account = {
    name       = module.storage_account.storage_name_data
    access_key = module.storage_account.storage_access_key_data
  }

  storage_account_api = {
    name       = module.storage_account.storage_api_name_data
    access_key = module.storage_account.storage_api_access_key_data
  }

  storage_account_jobs = {
    name       = module.storage_account.storage_jobs_name_data
    access_key = module.storage_account.storage_jobs_access_key_data
  }

  application_insights = {
    conenction_string = module.application_insights.azurerm_application_insights_connection_string
    key               = module.application_insights.azurerm_application_insights_instrumentation_key
  }

  appsettings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = module.application_insights.azurerm_application_insights_instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.application_insights.azurerm_application_insights_connection_string
    AZ_BLOB_CONNENDPOINT                  = module.storage_account.storage_container_supportdata_url
    AZ_BLOB_DATAFILES_CONNENDPOINT        = module.storage_account.storage_container_sgdata_url
    AZ_BLOB_DATAFILES_CONTAINER           = ""
    AZ_BLOB_SGFILES_CONNENDPOINT          = module.storage_account.storage_container_sgfiles_url
    AZ_GRAPHAPIAPP_CLIENT_CLIENTID        = var.GRAPHAPIAPP_CLIENT_CLIENTID
    AZ_GRAPHAPIAPP_CLIENT_SECRET          = ""
    AZ_GRAPHAPIAPP_CLIENT_TENANT          = var.GRAPHAPIAPP_CLIENT_TENANT
    AZ_KVAULT_URI                         = module.Key_Vault.key_vault_cred_vault_uri
    AZ_DATA_STORAGE_ACCOUNTNAME           = var.storage_name_data
    AZ_LOG_STORAGE_ACCOUNTNAME            = var.storage_name_log
    AZ_SB_DATAEV_TOPIC                    = tolist(var.list_of_servicebus_topics)[0]
    AZ_SB_DATAPULL_TOPIC                  = tolist(var.list_of_servicebus_topics)[1]
    AZ_SB_DATASERVICE_TOPIC               = tolist(var.list_of_servicebus_topics)[2]
    AZ_SB_RPTAUTOJOB_TOPIC                = tolist(var.list_of_servicebus_topics)[3]
    AZ_SB_RPTAUTOTASK_TOPIC               = tolist(var.list_of_servicebus_topics)[4]
    AZ_SB_DATAREV_TOPIC                   = tolist(var.list_of_servicebus_topics)[5]
    AZ_SB_ALARMSETJOB_TOPIC               = tolist(var.list_of_servicebus_topics)[6]
    AZ_SB_ALARMSETTASK_TOPIC              = tolist(var.list_of_servicebus_topics)[7]
    AZ_SB_CACHEMNGT_TOPIC                 = tolist(var.list_of_servicebus_topics)[8]
    AZ_SERVICEBUS_CONNSTR                 = ""
    AZ_SERVICEBUS_URI                     = ""
    SMTP_PASSWORD                         = ""
    SMTP_USERNAME                         = var.SMTP_USERNAME
    TWILIO_ACCSID                         = ""
    TWILIO_AUTHTOKEN                      = ""
    TWILIO_SMSFROM                        = var.TWILIO_SMSFROM
    AZ_DATA_STORAGE_CONTAINER             = ""
    WEATHER_API_KEY                       = ""
    WEATHER_API_URL                       = ""
    AZ_SB_DATAPROCESS_TOPIC               = ""
    AZ_SB_DATAPULL_SUSCRIPTION            = ""
    HANGFIRE_DASHBOARD_USER               = ""
    HANGFIRE_DASHBOARD_PASSWORD           = ""
    FTP_HOST                              = var.FTP_HOST
    FTP_PASSWORD                          = ""
    FTP_USERNAME                          = var.FTP_USERNAME
    AZ_SB_RPTAUTOJOB_SUSCRIPTION          = ""
  }

  dbs_connection_strings             = local.sql_connection_string
  dbs_connection_strings_for_web_app = local.sql_web_app_connection_string

  depends_on = [
    module.vnet,
    module.application_insights,
    module.service_bus,
    module.Key_Vault,
    module.storage_account
  ]
}

module "app_service_integration" {
  source                     = "./modules/app_service_plan_integration"
  key_vault_id               = module.Key_Vault.key_vault_id
  list_apps_identity         = module.app_service_plan.app_service_func_app_identity
  webapp_principal_id        = module.app_service_plan.web_app_principal_id
  storage_account_log_id     = module.storage_account.storage_id_log
  storage_account_data_id    = module.storage_account.storage_id_data
  sp_object_id               = var.sp_object_id
  cg_azure_geoview_object_id = var.sql_aad_admin.object_id
  key_vault_cred_id          = module.Key_Vault.key_vault_cred_id

  depends_on = [
    module.app_service_plan,
    module.storage_account
  ]
}

locals {
  sql_connection_string         = module.sql_server.sql_connection_string
  sql_web_app_connection_string = module.sql_server.sql_scheduler_connection_string
}

module "service_bus" {
  source                    = "./modules/service_bus"
  resource_group_location   = module.resource_group.resource_group_location
  resource_group_name       = module.resource_group.resource_group_name
  servicebus_namespace_name = var.servicebus_namespace_name
  list_of_servicebus_topics = var.list_of_servicebus_topics
  subnet_id                 = module.vnet.subnet_id_for_infra

  depends_on = [
    module.resource_group,
    module.vnet
  ]
}

module "static_web_site" {
  source                  = "./modules/static_web_site"
  static_site_name        = var.static_site_name
  resource_group_location = module.resource_group.resource_group_location
  resource_group_name     = module.resource_group.resource_group_name
}

module "key_vault_secret" {
  source                               = "./modules/key_vault_secret"
  servicebus_primary_connection_string = module.service_bus.servicebus_primary_connection_string
  key_vault_id                         = module.Key_Vault.key_vault_id
  secrets                              = var.secrets

  depends_on = [
    module.Key_Vault,
    module.app_service_integration,
    module.app_service_plan,
    module.service_bus
  ]
}
