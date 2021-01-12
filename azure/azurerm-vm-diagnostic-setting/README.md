# Azurerm VM

## Azure infrastructure

## terraform version
```
Terraform v0.13.5
+ provider registry.terraform.io/hashicorp/azurerm v2.29.0
```

## Usage

## VM Diagnostic Setting

| **Windows Default Diagnostic Setting** | **Linux Default Diagnostic Setting** |
| ---- | ---- |
|<u>Performance counters</U> <br> Collecting data for these counters: <br> <li>Processor</li><li>Processor Information</li><li>System</li><li>Process</li><li>Memory</li><li>LogicalDisk</li><li>Network Interface</li> <br><u>Event logs</u> <br>Collecting data for these logs:<br> <li>Application: Critical, Error, Warning</li><li>Security: Audit failur</li><li>System: Critical, Error, Warning</li> <br><u>Directories</u> <br> Not configured. <br><br><u>Crash dumps</u> <br> Not collecting memory dumps. <br><br> <u>Sinks</u> <br> Diagnostic data is not being sent to any sinks. <br><br> <u>Agent</u> <br> Diagnostic data is being sent to this storage account: mystg1234 <br><br> <u>Boot diagnostics</u> <br> Boot diagnostics is disabled. | <u>Metrics</u> <br>Collecting data for these metrics: <br> <li>disk</li><li>network</li><li>filesystem</li><li>processor</li><li>memory</li> <br> <u>Syslog</u> <br> Collecting logs for these facilities: <li>LOG_AUTH</li><li>LOG_AUTHPRIV</li><li>LOG_CRON</li><li>LOG_DAEMON</li><li>LOG_FTP</li><li>LOG_KERN</li><li>LOG_LOCAL0</li><li>LOG_LOCAL1</li><li>LOG_LOCAL2</li><li>LOG_LOCAL3</li><li>LOG_LOCAL4</li><li>LOG_LOCAL5</li><li>LOG_LOCAL6</li><li>LOG_LOCAL7</li><li>LOG_LPR</li><li>LOG_MAIL</li><li>LOG_NEWS</li><li>LOG_SYSLOG</li><li>LOG_USER</li><li>LOG_UUCP</li> <br> <u>Agent</u> <br> Diagnostic data is being sent to this storage account: mystg1234 <br><br> <u>Boot diagnostics</u> <br> Boot diagnostics is enabled  |

## run terraform

```
// Please specify the required values ​​for AWS resources in production/terraform.tfvars before deploy.

// terraform dry run
$ production/terraform plan

// terraform deploy
$ production/terraform apply
```
