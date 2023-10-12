#--------------------------------------------------------------
# CodeCommit
#--------------------------------------------------------------
resource "aws_codecommit_repository" "main" {
  repository_name = "codecommit-fargate-cicd"
}
