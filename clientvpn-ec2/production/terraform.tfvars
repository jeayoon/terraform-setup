#--------------------------------------------------------------
# TerraForm Variable Settings
#--------------------------------------------------------------
#AWS Settings
profile = ""
account_id = ""
account_name= ""

#env Name
env = "production"

client_domain = ""

#IP Settings
root_segment = "172.16.0.0/16"
app_private_segment1 = "172.16.11.0/24"
nat_public_segment = "172.16.200.0/24"
client_vpn_segment = "172.16.100.0/22"
my_global_id = ""
customer_global_ip = ""

#AZ Settings
segment1_az = "ap-northeast-1a"
segment2_az = "ap-northeast-1c"
segment3_az = "ap-northeast-1d"

#tfstate Settings
tfstate_bucket_name = "terraform-tfstate-bucket"

#ec2 Settings
ami = ""
instance_type = "t2.micro"
ssh_pub = ""

#vpc endpoint Settings
s3_service_name = "com.amazonaws.ap-northeast-1.s3"