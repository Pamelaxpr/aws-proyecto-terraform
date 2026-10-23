# services.tf - Definición y ejecución de contenedores

# 1. Definición de la Tarea (El "Plano" del contenedor)
resource "aws_ecs_task_definition" "api" {
  family                   = "${var.project_name}-api-task"
  network_mode             = "awsvpc" # Obligatorio para Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # 0.25 vCPU (Mínimo)
  memory                   = "512" # 512 MB (Mínimo)

  # Usamos una imagen pública de Nginx para simular que la API está viva
  container_definitions = jsonencode([
    {
      name      = "api-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# 2. El Servicio (El administrador que mantiene el contenedor encendido)
resource "aws_ecs_service" "api" {
  name            = "${var.project_name}-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  launch_type     = "FARGATE"
  desired_count   = 1 # Queremos que siempre haya 1 contenedor encendido

  # Lo ubicamos en las subredes PRIVADAS y le ponemos su escudo de seguridad
  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = false
  }

  # Lo conectamos al Balanceador de Carga
  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api-container"
    container_port   = 80
  }
}