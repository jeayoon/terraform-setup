#--------------------------------------------------------------
# Application Load Balancer
#--------------------------------------------------------------
resource "aws_lb" "main" {
  name               = "alb-fargate-cicd"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.pub_a1.id, aws_subnet.pub_c1.id]

  enable_deletion_protection = false
  tags                       = merge(var.tags, {})
}

resource "aws_lb_target_group" "blue" {
  name        = "lb-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
  tags = merge(var.tags, {})
}

resource "aws_lb_target_group" "green" {
  name        = "lb-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
  tags = merge(var.tags, {})
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
  tags = merge(var.tags, {})
}
