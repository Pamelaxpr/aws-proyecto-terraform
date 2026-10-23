variable "container_port" {
  description = "Puerto TCP en el que escucha la aplicacion dentro de la tarea ECS"
  type        = number
  default     = 8000
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Permitir HTTP publico y conectar solo al puerto de la aplicacion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Permitir trafico de aplicacion solo desde el ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-ecs-tasks-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "HTTP publico hacia el ALB"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_tasks" {
  security_group_id            = aws_security_group.alb_sg.id
  description                  = "El ALB solo puede conectar al puerto de la aplicacion"
  referenced_security_group_id = aws_security_group.ecs_tasks_sg.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "tasks_from_alb" {
  security_group_id            = aws_security_group.ecs_tasks_sg.id
  description                  = "La aplicacion solo recibe trafico en su puerto desde el ALB"
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "tasks_https" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  description       = "HTTPS saliente para dependencias como ECR"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}