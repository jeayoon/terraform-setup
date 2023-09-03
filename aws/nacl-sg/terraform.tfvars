# prj
project_name = "mytest" 
environment = "test"

# network
cidr_vpc = "10.0.0.0/16"
cidr_public1 = "10.0.10.0/24"
cidr_public2 = "10.0.30.0/24"
cidr_public3 = "10.0.50.0/24"
cidr_public4 = "10.0.70.0/24"
cidr_private1 = "10.0.20.0/24"
cidr_private2 = "10.0.40.0/24"
cidr_private3 = "10.0.60.0/24"
cidr_private4 = "10.0.80.0/24"

# # Bastion
bastion_ami = "ami-02c3627b04781eada"
bastion_instance_type = "t3.micro"
bastion_volume_size = "8"

# Private EC2
Private_EC2_ami = "ami-02c3627b04781eada"
Private_EC2_instance_type = "t3.micro"
Private_EC2_volume_size = "8"