{
	"storageAccountName": "${storage_name}",
	"storageAccountSasToken": "${storage_token}",
	"sinksConfig":  {
			"sink": [
				{
						"name": "SyslogJsonBlob",
						"type": "JsonBlob"
				},
				{
						"name": "LinuxCpuJsonBlob",
						"type": "JsonBlob"
				}
			]
		}
}