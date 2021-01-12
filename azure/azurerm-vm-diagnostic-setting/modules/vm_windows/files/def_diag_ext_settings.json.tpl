{
	"WadCfg": {
		"DiagnosticMonitorConfiguration": {
			"overallQuotaInMB": 5120,
			"DiagnosticInfrastructureLogs": {
				"scheduledTransferLogLevelFilter": "Error",
				"scheduledTransferPeriod"        : "PT1M"
			},
			"Directories": {
				"scheduledTransferPeriod": "PT1M"
			},
			"Metrics": {
				"MetricAggregation": [
					{
						"scheduledTransferPeriod": "PT1H"
					},
					{
						"scheduledTransferPeriod": "PT1M"
					}
				],
				"resourceId": "${vm_id}"
			},
			"PerformanceCounters": {
				"scheduledTransferPeriod": "PT1M",
				"PerformanceCounterConfiguration": [
					{
						"counterSpecifier": "\\Processor(_Total)\\% Processor Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\Processor Information(_Total)\\% Privileged Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\Processor Information(_Total)\\% User Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\Processor Information(_Total)\\Processor Frequency",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\System\\Processes",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\Process(_Total)\\Thread Count",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\Process(_Total)\\Handle Count",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\System\\System Up Time",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\System\\Context Switches/sec",
						"sampleRate": "PT60S",
						"unit": "CountPerSecond"
					},
					{
						"counterSpecifier": "\\System\\Processor Queue Length",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\Memory\\% Committed Bytes In Use",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\Memory\\Available Bytes",
						"sampleRate": "PT60S",
						"unit": "Bytes"
					},
					{
						"counterSpecifier": "\\Memory\\Committed Bytes",
						"sampleRate": "PT60S",
						"unit": "Bytes"
					},
					{
						"counterSpecifier": "\\Memory\\Cache Bytes",
						"sampleRate": "PT60S",
						"unit": "Bytes"
					},
					{
						"counterSpecifier": "\\Memory\\Pool Paged Bytes",
						"sampleRate": "PT60S",
						"unit": "Bytes"
					},
					{
						"counterSpecifier": "\\Memory\\Pool Nonpaged Bytes",
						"sampleRate": "PT60S",
						"unit": "Bytes"
					},
					{
						"counterSpecifier": "\\Memory\\Pages/sec",
						"sampleRate": "PT60S",
						"unit": "CountPerSecond"
					},
					{
						"counterSpecifier": "\\Memory\\Page Faults/sec",
						"sampleRate": "PT60S",
						"unit": "CountPerSecond"
					},
					{
						"counterSpecifier": "\\Process(_Total)\\Working Set",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\Process(_Total)\\Working Set - Private",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\% Disk Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\% Disk Read Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\% Disk Write Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\% Idle Time",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Disk Bytes/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Disk Transfers/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Disk Reads/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Disk Writes/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\% Free Space",
						"sampleRate": "PT60S",
						"unit": "Percent"
					},
					{
						"counterSpecifier": "\\LogicalDisk(_Total)\\Free Megabytes",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Bytes Total/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Bytes Sent/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Bytes Received/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Packets/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Packets Sent/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Packets Received/sec",
						"sampleRate": "PT60S",
						"unit": "BytesPerSecond"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Packets Outbound Errors",
						"sampleRate": "PT60S",
						"unit": "Count"
					},
					{
						"counterSpecifier": "\\Network Interface(*)\\Packets Received Errors",
						"sampleRate": "PT60S",
						"unit": "Count"
					}
				]
			},
			"WindowsEventLog": {
				"scheduledTransferPeriod": "PT1M",
					"DataSource": [
					{
						"name": "Application!*[System[(Level=1 or Level=2 or Level=3)]]"
					},
					{
						"name": "System!*[System[(Level=1 or Level=2 or Level=3)]]"
					},
					{
						"name": "Security!*[System[(band(Keywords,4503599627370496))]]"
					}
				]
			}
		}
	},
	"StorageAccount": "${storage_name}",
	"StorageType": "Blob"
}