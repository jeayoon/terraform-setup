#--------------------------------------------------------------
# TerraForm Variable Settings
#--------------------------------------------------------------
#AWS Settings
profile = ""
account_id = ""
account_name= ""

#env Name
env = ""

client_domain = ""

#IP Settings
root_segment = ""
app_private_segment1 = ""
nat_public_segment = ""
client_vpn_segment = ""
my_global_id = ""
customer_global_ip = ""

#AZ Settings
segment1_az = "ap-northeast-1a"
segment2_az = "ap-northeast-1c"
segment3_az = "ap-northeast-1d"

#tfstate Settings
tfstate_bucket_name = ""

#ec2 Settings
ami = ""
instance_type = ""
ssh_pub = ""

#vpc endpoint Settings
s3_service_name = "com.amazonaws.ap-northeast-1.s3"