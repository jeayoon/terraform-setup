#--------------------------------------------------------------
# TerraForm Variable Settings
#--------------------------------------------------------------
#Azure Settings
subscription_id = ""
tenant_id = ""
location = "japaneast"
resource_group_name = "myResourceGroupTerraform"
virtual_network_name = "myVNTerraform"
log_analytics_workspace_name = "TerraformLogAnalyticsWorkspaceName"
log_analytics_workspace_sku = "PerGB2018"
log_analytics_workspace_location = "eastus"
cluster_name = "k8sterraform"
dns_prefix = "k8sterraform"
ssh_public_key = "~/.ssh/azure/id_rsa.pub"
agent_count = 3