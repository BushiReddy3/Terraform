locals {
  api_filter  = ""
  jobs_filter = ""

  dynamic_connection_strings_for_web_app = [{
    name  = ""
    value = local.connection_strings_for_web_app
    type  = ""
    },
    {
      name  = ""
      value = local.connection_strings_for_func_app
      type  = ""
    }
  ]

  dynamic_connection_strings_for_fun_app_jobs = [
    {
      name  = ""
      value = local.connection_strings_for_func_app
      type  = ""
    }
  ]

  connection_strings_for_func_app = var.dbs_connection_strings
  connection_strings_for_web_app  = var.dbs_connection_strings_for_web_app

  app_settings_for_api_main = tomap({
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.appsettings.APPINSIGHTS_INSTRUMENTATIONKEY,
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.appsettings.APPLICATIONINSIGHTS_CONNECTION_STRING,
    "AZ_BLOB_CONNENDPOINT"                  = var.appsettings.AZ_BLOB_CONNENDPOINT,
    "AZ_BLOB_DATAFILES_CONNENDPOINT"        = var.appsettings.AZ_BLOB_DATAFILES_CONNENDPOINT,
    "AZ_BLOB_DATAFILES_CONTAINER"           = var.appsettings.AZ_BLOB_DATAFILES_CONTAINER,
    "AZ_BLOB_SGFILES_CONNENDPOINT"          = var.appsettings.AZ_BLOB_SGFILES_CONNENDPOINT,
    "AZ_GRAPHAPIAPP_CLIENT_CLIENTID"        = var.appsettings.AZ_GRAPHAPIAPP_CLIENT_CLIENTID,
    "AZ_GRAPHAPIAPP_CLIENT_SECRET"          = var.appsettings.AZ_GRAPHAPIAPP_CLIENT_SECRET,
    "AZ_GRAPHAPIAPP_CLIENT_TENANT"          = var.appsettings.AZ_GRAPHAPIAPP_CLIENT_TENANT,
    "AZ_KVAULT_URI"                         = var.appsettings.AZ_KVAULT_URI,
    "AZ_LOG_STORAGE_ACCOUNTNAME"            = var.appsettings.AZ_LOG_STORAGE_ACCOUNTNAME,
    "AZ_SB_DATAEV_TOPIC"                    = var.appsettings.AZ_SB_DATAEV_TOPIC,
    "AZ_SB_DATAPULL_TOPIC"                  = var.appsettings.AZ_SB_DATAPULL_TOPIC,
    "AZ_SB_DATASERVICE_TOPIC"               = var.appsettings.AZ_SB_DATASERVICE_TOPIC,
    "AZ_SB_RPTAUTOJOB_TOPIC"                = var.appsettings.AZ_SB_RPTAUTOJOB_TOPIC,
    "AZ_SB_RPTAUTOTASK_TOPIC"               = var.appsettings.AZ_SB_RPTAUTOTASK_TOPIC,
    "AZ_SB_DATAREV_TOPIC"                   = var.appsettings.AZ_SB_DATAREV_TOPIC,
    "AZ_SB_ALARMSETJOB_TOPIC"               = var.appsettings.AZ_SB_ALARMSETJOB_TOPIC,
    "AZ_SB_ALARMSETTASK_TOPIC"              = var.appsettings.AZ_SB_ALARMSETTASK_TOPIC,
    "AZ_SB_CACHEMNGT_TOPIC"                 = var.appsettings.AZ_SB_CACHEMNGT_TOPIC,
    "AZ_SERVICEBUS_CONNSTR"                 = var.appsettings.AZ_SERVICEBUS_CONNSTR,
    "AZ_SERVICEBUS_URI"                     = var.appsettings.AZ_SERVICEBUS_URI,
    "SMTP_PASSWORD"                         = var.appsettings.SMTP_PASSWORD,
    "SMTP_USERNAME"                         = var.appsettings.SMTP_USERNAME,
    "TWILIO_ACCSID"                         = var.appsettings.TWILIO_ACCSID,
    "TWILIO_AUTHTOKEN"                      = var.appsettings.TWILIO_AUTHTOKEN,
    "TWILIO_SMSFROM"                        = var.appsettings.TWILIO_SMSFROM,
    "FTP_HOST"                              = var.appsettings.FTP_HOST,
    "FTP_PASSWORD"                          = var.appsettings.FTP_PASSWORD,
    "FTP_USERNAME"                          = var.appsettings.FTP_USERNAME
  })

  app_settings_for_jobs = tomap({
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.appsettings.APPINSIGHTS_INSTRUMENTATIONKEY,
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.appsettings.APPLICATIONINSIGHTS_CONNECTION_STRING,
    "AZ_BLOB_CONNENDPOINT"                  = var.appsettings.AZ_BLOB_CONNENDPOINT,
    "AZ_BLOB_DATAFILES_CONNENDPOINT"        = var.appsettings.AZ_BLOB_DATAFILES_CONNENDPOINT,
    "AZ_BLOB_SGFILES_CONNENDPOINT"          = var.appsettings.AZ_BLOB_SGFILES_CONNENDPOINT,
    "AZ_GRAPHAPIAPP_CLIENT_CLIENTID"        = var.appsettings.AZ_GRAPHAPIAPP_CLIENT_CLIENTID,
    "AZ_GRAPHAPIAPP_CLIENT_SECRET"          = var.appsettings.AZ_GRAPHAPIAPP_CLIENT_SECRET,
    "AZ_GRAPHAPIAPP_CLIENT_TENANT"          = var.appsettings.AZ_GRAPHAPIAPP_CLIENT_TENANT,
    "AZ_KVAULT_URI"                         = var.appsettings.AZ_KVAULT_URI,
    "AZ_DATA_STORAGE_ACCOUNTNAME"           = var.appsettings.AZ_DATA_STORAGE_ACCOUNTNAME,
    "AZ_LOG_STORAGE_ACCOUNTNAME"            = var.appsettings.AZ_LOG_STORAGE_ACCOUNTNAME,
    "AZ_SB_DATAEV_TOPIC"                    = var.appsettings.AZ_SB_DATAEV_TOPIC,
    "AZ_SB_DATAPULL_TOPIC"                  = var.appsettings.AZ_SB_DATAPULL_TOPIC,
    "AZ_SB_DATASERVICE_TOPIC"               = var.appsettings.AZ_SB_DATASERVICE_TOPIC,
    "AZ_SB_RPTAUTOJOB_TOPIC"                = var.appsettings.AZ_SB_RPTAUTOJOB_TOPIC,
    "AZ_SB_ALARMSETJOB_TOPIC"               = var.appsettings.AZ_SB_ALARMSETJOB_TOPIC,
    "AZ_SB_ALARMSETTASK_TOPIC"              = var.appsettings.AZ_SB_ALARMSETTASK_TOPIC,
    "AZ_SB_CACHEMNGT_TOPIC"                 = var.appsettings.AZ_SB_CACHEMNGT_TOPIC,
    "AZ_SERVICEBUS_CONNSTR"                 = var.appsettings.AZ_SERVICEBUS_CONNSTR,
    "SMTP_PASSWORD"                         = var.appsettings.SMTP_PASSWORD,
    "SMTP_USERNAME"                         = var.appsettings.SMTP_USERNAME,
    "TWILIO_ACCSID"                         = var.appsettings.TWILIO_ACCSID,
    "TWILIO_AUTHTOKEN"                      = var.appsettings.TWILIO_AUTHTOKEN,
    "TWILIO_SMSFROM"                        = var.appsettings.TWILIO_SMSFROM,
    "AZ_DATA_STORAGE_CONTAINER"             = var.appsettings.AZ_DATA_STORAGE_CONTAINER,
    "WEATHER_API_KEY"                       = var.appsettings.WEATHER_API_KEY,
    "WEATHER_API_URL"                       = var.appsettings.WEATHER_API_URL,
    "FTP_HOST"                              = var.appsettings.FTP_HOST,
    "FTP_PASSWORD"                          = var.appsettings.FTP_PASSWORD,
    "FTP_USERNAME"                          = var.appsettings.FTP_USERNAME
  })


  app_settings_for_scheduler = tomap({
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.appsettings.APPINSIGHTS_INSTRUMENTATIONKEY,
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.appsettings.APPLICATIONINSIGHTS_CONNECTION_STRING,
    "AZ_BLOB_CONNENDPOINT"                  = var.appsettings.AZ_BLOB_CONNENDPOINT,
    "AZ_BLOB_DATAFILES_CONNENDPOINT"        = var.appsettings.AZ_BLOB_DATAFILES_CONNENDPOINT,
    "AZ_BLOB_SGFILES_CONNENDPOINT"          = var.appsettings.AZ_BLOB_SGFILES_CONNENDPOINT,
    "AZ_KVAULT_URI"                         = var.appsettings.AZ_KVAULT_URI,
    "AZ_DATA_STORAGE_ACCOUNTNAME"           = var.appsettings.AZ_DATA_STORAGE_ACCOUNTNAME,
    "AZ_LOG_STORAGE_ACCOUNTNAME"            = var.appsettings.AZ_LOG_STORAGE_ACCOUNTNAME,
    "AZ_SB_DATAEV_TOPIC"                    = var.appsettings.AZ_SB_DATAEV_TOPIC,
    "AZ_SB_DATAPULL_TOPIC"                  = var.appsettings.AZ_SB_DATAPULL_TOPIC,
    "AZ_SB_DATASERVICE_TOPIC"               = var.appsettings.AZ_SB_DATASERVICE_TOPIC,
    "AZ_SB_ALARMSETJOB_TOPIC"               = var.appsettings.AZ_SB_ALARMSETJOB_TOPIC,
    "AZ_SB_ALARMSETTASK_TOPIC"              = var.appsettings.AZ_SB_ALARMSETTASK_TOPIC,
    "AZ_SB_CACHEMNGT_TOPIC"                 = var.appsettings.AZ_SB_CACHEMNGT_TOPIC,
    "AZ_SERVICEBUS_CONNSTR"                 = var.appsettings.AZ_SERVICEBUS_CONNSTR,
    "SMTP_PASSWORD"                         = var.appsettings.SMTP_PASSWORD,
    "SMTP_USERNAME"                         = var.appsettings.SMTP_USERNAME,
    "TWILIO_ACCSID"                         = var.appsettings.TWILIO_ACCSID,
    "TWILIO_AUTHTOKEN"                      = var.appsettings.TWILIO_AUTHTOKEN,
    "TWILIO_SMSFROM"                        = var.appsettings.TWILIO_SMSFROM,
    "AZ_DATA_STORAGE_CONTAINER"             = var.appsettings.AZ_DATA_STORAGE_CONTAINER,
    "WEATHER_API_KEY"                       = var.appsettings.WEATHER_API_KEY,
    "WEATHER_API_URL"                       = var.appsettings.WEATHER_API_URL,
    "AZ_SB_DATAPROCESS_TOPIC"               = var.appsettings.AZ_SB_DATAPROCESS_TOPIC,
    "AZ_SB_DATAPULL_SUSCRIPTION"            = var.appsettings.AZ_SB_DATAPULL_SUSCRIPTION,
    "HANGFIRE_DASHBOARD_USER"               = var.appsettings.HANGFIRE_DASHBOARD_USER,
    "HANGFIRE_DASHBOARD_PASSWORD"           = var.appsettings.HANGFIRE_DASHBOARD_PASSWORD,
    "FTP_HOST"                              = var.appsettings.FTP_HOST,
    "FTP_PASSWORD"                          = var.appsettings.FTP_PASSWORD,
    "FTP_USERNAME"                          = var.appsettings.FTP_USERNAME,
    "AZ_SB_RPTAUTOTASK_TOPIC"               = var.appsettings.AZ_SB_RPTAUTOTASK_TOPIC,
    "AZ_SB_DATAREV_TOPIC"                   = var.appsettings.AZ_SB_DATAREV_TOPIC
    "AZ_SB_RPTAUTOJOB_TOPIC"                = var.appsettings.AZ_SB_RPTAUTOJOB_TOPIC,
    "AZ_SB_RPTAUTOJOB_SUSCRIPTION"          = var.appsettings.AZ_SB_RPTAUTOJOB_SUSCRIPTION,
    "AZ_BLOB_DATAFILES_CONTAINER"           = var.appsettings.AZ_BLOB_DATAFILES_CONTAINER,
    "AZ_BLOB_CONNENDPOINT"                  = var.appsettings.AZ_BLOB_CONNENDPOINT,
    "AZ_BLOB_DATAFILES_CONNENDPOINT"        = var.appsettings.AZ_BLOB_DATAFILES_CONNENDPOINT,
    "AZ_BLOB_SGFILES_CONNENDPOINT"          = var.appsettings.AZ_BLOB_SGFILES_CONNENDPOINT
  })

  #This is only for Development environment.
  app_settings_for_api_for_dev_env = tomap({
    "AzureFunctionsJobHost__logging__logLevel__Default" = "Trace"
  })

  app_settings_for_api = var.is_dev_env ? merge(local.app_settings_for_api_main, local.app_settings_for_api_for_dev_env) : local.app_settings_for_api_main

  app_settings_for_api_for_xyz = tomap({
    "CODE" = ""
  })

  app_settings_for_api_for_abc = tomap({
    "VERTICAL_CODE" = ""
  })

  app_settings_for_xyz_api = merge(local.app_settings_for_api, local.app_settings_for_api_for_xyz)

  app_settings_for_abc_api = merge(local.app_settings_for_api, local.app_settings_for_api_for_abc)

}
