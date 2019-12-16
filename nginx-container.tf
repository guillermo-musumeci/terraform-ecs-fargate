# nginx container | nginx-container.tf

# container template
data "template_file" "nginx_app" {
  template = file("./nginx.json")

  vars = {
    app_name       = var.nginx_app_name
    app_image      = var.nginx_app_image
    app_port       = var.nginx_app_port
    fargate_cpu    = var.nginx_fargate_cpu
    fargate_memory = var.nginx_fargate_memory
    aws_region     = var.aws_region
  }
}

# ECS task definition
resource "aws_ecs_task_definition" "nginx_app" {
  family                   = "nginx-task"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.nginx_fargate_cpu
  memory                   = var.nginx_fargate_memory
  container_definitions    = data.template_file.nginx_app.rendered
}

# ECS service
resource "aws_ecs_service" "nginx_app" {
  name            = var.nginx_app_name
  cluster         = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.nginx_app.arn
  desired_count   = var.nginx_app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.aws-ecs-tasks.id]
    subnets          = aws_subnet.aws-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx_app.id
    container_name   = var.nginx_app_name
    container_port   = var.nginx_app_port
  }

  depends_on = [aws_alb_listener.front_end]

   tags = {
    Name = "${var.nginx_app_name}-nginx-ecs"
  }
}

 