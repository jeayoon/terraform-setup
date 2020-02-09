#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "env" {}
variable "db_name" {}
variable "db_sg_id" {}
variable "db_username" {}
variable "db_password" {}
variable "segment1_az" {}
variable "db_subnet1_id" {}
variable "db_subnet2_id" {}
variable "account_name" {}
variable "ec2_instance_id" {}
variable "db_instance_class" {}
variable "db_allocated_storage" {}

#--------------------------------------------------------------
#RDS Settings
#--------------------------------------------------------------
resource "aws_db_subnet_group" "main" {
    name = "${var.account_name}-${var.env}-subnet-group"
    description = "rds subnet group"
    subnet_ids = [var.db_subnet1_id, var.db_subnet2_id]
}

resource "aws_db_parameter_group" "main" {
    name   = "${var.account_name}-${var.env}-pg"
    family = "mysql8.0"

    parameter {
        name  = "time_zone"
        value = "Asia/Tokyo"
    }
}

resource "aws_db_instance" "main" {
  identifier                 = "${var.account_name}-${var.env}-rds"
  allocated_storage          = var.db_allocated_storage
  storage_type               = "gp2"
  engine                     = "mysql"
  engine_version             = "8.0.11"
  instance_class             = var.db_instance_class
  name                       = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  port                       = 3306
  publicly_accessible        = false
  security_group_names       = []
  vpc_security_group_ids     = [var.db_sg_id]
  db_subnet_group_name       = aws_db_subnet_group.main.name
  parameter_group_name       = aws_db_parameter_group.main.name
  availability_zone　　　　　　= var.segment1_az
  multi_az                   = false
  backup_retention_period    = var.db_backup_retention_period
  backup_window              = "13:24-13:54"
  maintenance_window         = "tue:16:11-tue:16:41"
  auto_minor_version_upgrade = false
  copy_tags_to_snapshot      = true
  skip_final_snapshot        = true
  enabled_cloudwatch_logs_exports  = ["mysql"]
  deletion_protection        = true

  tags = {
    workload-type = "other"
  }

  lifecycle {
    ignore_changes = [
      "password",
    ]
  }
}
