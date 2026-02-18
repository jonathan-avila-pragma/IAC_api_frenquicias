############################
# CLOUDWATCH LOG GROUP
############################

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/franchise-api"
  retention_in_days = 7
}

############################
# ECS CLUSTER
############################

resource "aws_ecs_cluster" "main" {
  name = "franchise-cluster"
}

############################
# TASK DEFINITION
############################

resource "aws_ecs_task_definition" "app" {
  family                   = "franchise-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "franchise-api"
      image = aws_ecr_repository.app.repository_url
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "MONGODB_HOST"
          value = var.mongodb_host
        },
        {
          name  = "MONGODB_DATABASE"
          value = var.mongodb_database
        },
        {
          name  = "SERVER_PORT"
          value = var.server_port
        },
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = var.spring_profile
        }
      ]

      secrets = [
        {
          name      = "MONGODB_USERNAME"
          valueFrom = "${aws_secretsmanager_secret.mongo.arn}:username::"
        },
        {
          name      = "MONGODB_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.mongo.arn}:password::"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/franchise-api"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

############################
# ECS SERVICE
############################

resource "aws_ecs_service" "app" {
  name            = "franchise-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "franchise-api"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.http
  ]
}
