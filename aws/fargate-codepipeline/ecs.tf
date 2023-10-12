#--------------------------------------------------------------
# IAM
#--------------------------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "MyECS-TaskExecutionRole"
  assume_role_policy = templatefile("./files/assumerole.json.tpl", { resource = "ecs-tasks" })
}
# Provides access to other AWS service resources that are required to run Amazon ECS tasks
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "MyECS-TaskRole"
  assume_role_policy = templatefile("./files/assumerole.json.tpl", { resource = "ecs-tasks" })
}
# Allow the containers in your task to assume an IAM role to call AWS APIs without having to use AWS Credentials inside the containers.
resource "aws_iam_role_policy" "task-policy" {
  role   = aws_iam_role.task_role.name
  policy = templatefile("./files/ecs_task_policy.json.tpl", {})
}

#--------------------------------------------------------------
# Cloudwatch Log Group
#--------------------------------------------------------------
resource "aws_cloudwatch_log_group" "nginx" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 1
}

#--------------------------------------------------------------
# ECS
#--------------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "ecs-fargate-cicd"
  tags = merge(var.tags, {})
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "main" {
  family                   = "my-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = templatefile("./files/container_definitions.json.tpl", {
    container_name            = var.container_name,
    container_port            = var.container_port,
    container_image           = local.container_image,
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
  })
}

resource "aws_ecs_service" "main" {
  name                               = "service-fargate-cicd"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  enable_execute_command             = true

  network_configuration {
    security_groups = [aws_security_group.app.id]
    subnets         = [aws_subnet.prv_a1.id, aws_subnet.prv_c1.id]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count, load_balancer]
  }
  depends_on = [aws_lb.main]

}

