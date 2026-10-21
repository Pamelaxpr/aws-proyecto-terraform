# security.tf - Grupos de Seguridad (Firewalls)

# 1. Firewall para el Balanceador de Carga (Público)
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Permitir trafico web desde internet hacia el balanceador"
  vpc_id      = aws_vpc.main.id

  # Regla de entrada: Permitir tráfico HTTP (puerto 80) desde cualquier IP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida: Permitir que el balanceador envíe datos hacia adentro
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# 2. Firewall para los contenedores Fargate (Privado)
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Permitir trafico solo desde el balanceador de carga"
  vpc_id      = aws_vpc.main.id

  # Regla de entrada: Aislar los contenedores. Solo entra tráfico del ALB_SG.
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Regla de salida: Permitir salir a internet (necesario para descargar imagenes desde ECR)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}