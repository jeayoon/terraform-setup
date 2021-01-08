#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
#AWS Settings
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "app_name" {}

variable "artifact_bucket_name" {}

variable "github_account_name" {}
variable "github_project_url" {}
variable "github_token" {}
variable "github_repository_name" {}
variable "github_branch" {}


variable "codebuild_name" {}
variable "buildspec_path" {}
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}
variable "imagedefinitions_path" {}

variable "slack_webhook" {}
