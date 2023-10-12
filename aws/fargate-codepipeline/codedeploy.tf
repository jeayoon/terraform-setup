#--------------------------------------------------------------
# CodeDeploy
#--------------------------------------------------------------
resource "aws_iam_role" "codedeploy-role" {
  name               = "MyCodedeploy-Role"
  assume_role_policy = templatefile("./files/assumerole.json.tpl", { resource = "codedeploy" })
}
resource "aws_iam_role_policy" "codedeploy-policy" {
  role   = aws_iam_role.codedeploy-role.name
  policy = templatefile("./files/codedeploy_policy.json.tpl", {})
}

resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = "codedeploy-fargate-cicd"
}

resource "aws_codedeploy_deployment_group" "main" {
  app_name               = aws_codedeploy_app.main.name
  deployment_group_name  = "codedeployGroup-fg"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy-role.arn

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.main.name
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }

}
