#--------------------------------------------------------------
# S3
#--------------------------------------------------------------
resource "aws_s3_bucket" "artifact" {
  bucket = "my-artifact2023"

  tags = merge(var.tags, { "Name" = "MyArtifact" })
}

#--------------------------------------------------------------
# SSM Parameter Store
#--------------------------------------------------------------
resource "aws_ssm_parameter" "id" {
  name  = "MY_ACCOUNT_ID"
  type  = "String"
  value = local.account_id
}

#--------------------------------------------------------------
# CodeBuild
#--------------------------------------------------------------
resource "aws_iam_role" "codebuild-role" {
  name               = "MyCodebuild-Role"
  assume_role_policy = templatefile("./files/assumerole.json.tpl", { resource = "codebuild" })
}
resource "aws_iam_role_policy" "codebuild-policy" {
  role = aws_iam_role.codebuild-role.name
  policy = templatefile("./files/codebuild_policy.json.tpl", {
    region           = var.region
    account_id       = local.account_id
    codebuild_name   = aws_codebuild_project.main.name
    bucket_name      = aws_s3_bucket.artifact.id
    param_store_name = aws_ssm_parameter.id.name
  })
}

resource "aws_codebuild_project" "main" {
  name         = "codebuild-fargate-cicd"
  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.main.clone_url_http
  }

  source_version = "main"

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "ECR_NAME"
      value = aws_ecr_repository.main.name
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

    environment_variable {
      name  = "TASK_FAMILY"
      value = aws_ecs_task_definition.main.family
    }

    environment_variable {
      name  = "TASK_ROLE_NAME"
      value = aws_iam_role.task_role.name
    }

    environment_variable {
      name  = "EXECUTION_ROLE_NAME"
      value = aws_iam_role.ecs_task_execution_role.name
    }

    environment_variable {
      name  = "LOGS_GROUP"
      value = var.cloudwatch_log_group_name
    }
  }
}
