#--------------------------------------------------------------
# TerraForm Variable Settings
#--------------------------------------------------------------
#AWS Settings
profile = "tokyo-nokodai"
account_id = "215498972963"
account_name= "tokyo-nokodai-ml"

#env Name
env = "production"

client_domain = "eeainet.jp"

#IP Settings
root_segment = "172.16.0.0/16"
app_private_segment1 = "172.16.11.0/24"
nat_public_segment = "172.16.200.0/24"
client_vpn_segment = "172.16.100.0/22"
fusic_global_id = "116.94.0.124/32"
customer_global_ip = "165.93.161.6/32"

#AZ Settings
segment1_az = "ap-northeast-1a"
segment2_az = "ap-northeast-1c"
segment3_az = "ap-northeast-1d"

#tfstate Settings
tfstate_bucket_name = "terraform-tfstate-bucket"

#ec2 Settings
ami = "ami-07729b5941107618c"  // Deep Learning AMI
instance_type = "t2.micro"
ssh_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCHxfqgGMxk4zojwl4oMsk9sra9Tr6qP8e+lxOK2rVk9D4gZA0nKykJUPMQZnZUf/XW6stuE9pTDcz93qboZ6QXKun7qRaxHhdvwAz6/uRg2mrOKxcKof7P7+aR54FuAbd29zshYfZwCjLjOvwPlYlnBbh24i4h0kLpaIesZTaZM23+2dorFCzJ7/kZm4qIc+6UOOxCJtdCRIwm+5uNnjmwFbrUzCQr9ehhIANOCwGrKQBdUWlZgBobyKA4Mlho7dKOcJcAAtUb2hpB/qZXH+PQxRougSX0Pbez1MFpJKrm/Rm7IQs2BHuvh70A8usOjz/yZGKrS7XBB35kt42TyB29"

#vpc endpoint Settings
s3_service_name = "com.amazonaws.ap-northeast-1.s3"