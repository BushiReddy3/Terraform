variable "resource_group_name" {
  type        = string
  description = "Name of the resource group name"
}

variable "resource_group_location" {
  type        = string
  description = "Name of the resource group location"
}

variable "app_service_plan_sku_name" {
  type = string
}

variable "app_service_plan_name" {
  type = string
}

variable "windows_web_app_name" {
  type = string
}

variable "storage_account" {
  type = object({
    name       = string
    access_key = string
  })
}

variable "storage_account_api" {
  type = object({
    name       = string
    access_key = string
  })
}

variable "storage_account_jobs" {
  type = object({
    name       = string
    access_key = string
  })
}


variable "application_insights" {
  type = object({
    conenction_string = string
    key               = string
  })
}

variable "dbs_connection_strings" {
  type = string
}

variable "dbs_connection_strings_for_web_app" {
  type = string
}

variable "apps" {
  type = map(string)
}

variable "key_vault_id" {
  type = string
}

variable "appsettings" {
  type = object({
    APPINSIGHTS_INSTRUMENTATIONKEY        = string
    APPLICATIONINSIGHTS_CONNECTION_STRING = string
    AZ_BLOB_CONNENDPOINT                  = string
    AZ_BLOB_DATAFILES_CONNENDPOINT        = string
    AZ_BLOB_DATAFILES_CONTAINER           = string
    AZ_BLOB_SGFILES_CONNENDPOINT          = string
    AZ_GRAPHAPIAPP_CLIENT_CLIENTID        = string
    AZ_GRAPHAPIAPP_CLIENT_SECRET          = string
    AZ_GRAPHAPIAPP_CLIENT_TENANT          = string
    AZ_KVAULT_URI                         = string
    AZ_DATA_STORAGE_ACCOUNTNAME           = string
    AZ_LOG_STORAGE_ACCOUNTNAME            = string
    AZ_SB_DATAEV_TOPIC                    = string
    AZ_SB_DATAPULL_TOPIC                  = string
    AZ_SB_DATASERVICE_TOPIC               = string
    AZ_SB_ALARMSETJOB_TOPIC               = string
    AZ_SB_ALARMSETTASK_TOPIC              = string
    AZ_SB_RPTAUTOJOB_TOPIC                = string
    AZ_SB_RPTAUTOTASK_TOPIC               = string
    AZ_SB_DATAREV_TOPIC                   = string
    AZ_SB_CACHEMNGT_TOPIC                 = string
    AZ_SERVICEBUS_CONNSTR                 = string
    AZ_SERVICEBUS_URI                     = string
    SMTP_PASSWORD                         = string
    SMTP_USERNAME                         = string
    TWILIO_ACCSID                         = string
    TWILIO_AUTHTOKEN                      = string
    TWILIO_SMSFROM                        = string
    AZ_DATA_STORAGE_CONTAINER             = string
    WEATHER_API_KEY                       = string
    WEATHER_API_URL                       = string
    AZ_SB_DATAPROCESS_TOPIC               = string
    AZ_SB_DATAPULL_SUSCRIPTION            = string
    HANGFIRE_DASHBOARD_USER               = string
    HANGFIRE_DASHBOARD_PASSWORD           = string
    FTP_HOST                              = string
    FTP_PASSWORD                          = string
    FTP_USERNAME                          = string
    AZ_SB_RPTAUTOJOB_SUSCRIPTION          = string
  })
}

variable "vnet_subnet_id_for_web" {
  type = string
}

variable "vnet_subnet_id_for_app" {
  type = string
}

variable "is_dev_env" {
  type = bool
}

variable "header_x_azure_fdid_for_api" {
  type = list(string)
}

variable "ip_addresses" {

}

variable "allowed_origins" {
  type = list(string)
}

variable "client_id" {
  type = string
}

variable "issuer" {
  type = string
}

variable "sp_subscription_id" {
  type      = string
  sensitive = true
}
