#--------------------------------------------------------------
# CodeBuild Settings
#--------------------------------------------------------------
resource "aws_codebuild_project" "main_build" {
  name          = "${var.codebuild_name}"
  description   = "create for codepipeline stage"
  build_timeout = "60"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type            = "GITHUB"
    location        = "${var.github_project_url}" //GitHub project URL
    git_clone_depth = 1
    buildspec       = "${var.buildspec_path}"     //GitHubにあるbuildspec.ymlの場所
  }
}

#--------------------------------------------------------------
# CodePipeline Settings
#--------------------------------------------------------------
resource "aws_codepipeline" "main" {
  name     = "codepipeline-main"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifact.bucket}"
    type     = "S3"

    encryption_key {
      id   = "${data.aws_kms_alias.s3kmskey.arn}"
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        Owner  = "${var.github_account_name}" // GitHub アカウント名
        OAuthToken = "${var.github_token}"    // GitHub Token
        Repo   = "${var.github_repository_name}"   // GitHubリポジトリ名
        Branch = "${var.github_branch}"       // GitHub push先
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      version          = "1"

      configuration = {
        ProjectName = "${var.codebuild_name}" //CodeBuild名
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build"]
      version         = "1"

      configuration = {
        ClusterName = "${var.ecs_cluster_name}"      //AWS ECS Cluster名
        ServiceName = "${var.ecs_service_name}"      //AWS ECS Service名
        FileName    = "${var.imagedefinitions_path}" //GitHubにあるimagedefinitions.json場所
      }
    }
  }
}