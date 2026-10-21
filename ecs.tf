# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  # Container Insights nos permite ver métricas detalladas de CPU y memoria 
  # de nuestros contenedores (muy útil para DevOps/Monitoreo)
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

# Fargate Capacity Provider: Le dice al cluster que use infraestructura "Serverless" (Fargate)
# en lugar de servidores EC2 tradicionales.
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}