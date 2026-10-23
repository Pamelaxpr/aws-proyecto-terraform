
# 🚀 Proyecto: Migración a AWS ECS Fargate con Terraform

Este proyecto es una prueba de concepto (PoC) en local para aprender a migrar una infraestructura IoT de Telemática de vehículos (basada en instancias EC2 antiguas) a una arquitectura de microservicios moderna sin servidor usando **AWS ECS Fargate**.

La infraestructura se despliega íntegramente mediante **Terraform** simulando la nube local con **Floci** (LocalStack).

## 🗺️ Mapa de Ruta del Proyecto

La arquitectura objetivo se divide en varias fases. Aquí marcamos nuestro progreso:

- [x] **Fase 1: Redes (VPC y Subredes)**
  - Archivo: `vpc.tf`
  - Qué hace: Crea una red privada virtual (`10.0.0.0/16`) aislada, con 2 subredes públicas (para los balanceadores) y 2 privadas (para los contenedores).

- [x] **Fase 2: Registros Docker (ECR)**
  - Archivo: `ecr.tf`
  - Qué hace: Prepara los repositorios para almacenar las imágenes Docker de nuestros 4 microservicios en Python/FastAPI (`telematics-ingestion`, `telematics-mapping`, `telematics-events`, `telematics-api`).

- [x] **Fase 3: Motor de Ejecución (Cluster ECS)** 
  - Archivo: `ecs.tf`
  - Qué hace: Crea el clúster base que administrará los contenedores utilizando el proveedor de capacidad Fargate (Serverless).

- [x] **Fase 4: Seguridad y Reglas de Tráfico**
  - Archivo: `security.tf`
  - Qué hará: Crear Grupos de Seguridad (Firewalls) para garantizar que los contenedores en las redes privadas solo reciban tráfico autorizado.

- [x] **Fase 5: Balanceador de Carga (ALB)**
  - Archivo: `alb.tf`
  - Qué hará: Distribuir el tráfico de internet hacia los contenedores de la API y los WebSockets persistentes de los GPS.

- [ ] **Fase 6: Tareas Fargate y Servicios**
  - Archivos: `tasks.tf` y `services.tf`
  - Qué hará: Desplegar los 4 microservicios dentro del clúster conectándolos entre sí.

## ⚙️ Cómo ejecutar este proyecto en local

1. Asegúrate de tener Floci ejecutándose en tu ordenador.
2. Clona este repositorio y abre una terminal.
3. Ejecuta `terraform init` para descargar los proveedores.
4. Ejecuta `terraform apply` y escribe `yes` para construir la infraestructura.

```text
aws-telematics-infrastructure/
├── .gitignore
├── README.md
├── environments/
│   └── prod/                 # Aquí definimos la infraestructura final invocando módulos
│       ├── backend.tf        # Configuración del estado remoto (S3)
│       ├── main.tf           # Llamadas a los módulos
│       ├── variables.tf      # Variables del entorno
│       └── terraform.tfvars  # Valores reales de las variables (NO se sube a GitHub si hay secretos)
└── modules/                  # Componentes reutilizables
    ├── networking/           # VPC, Subredes, NAT Gateway, Tablas de ruteo
    ├── ecr/                  # Repositorios de imágenes Docker
    ├── ecs_cluster/          # El cluster base de Fargate
    ├── ecs_service/          # Plantilla genérica para lanzar cada microservicio
    └── databases/            # Amazon MQ (RabbitMQ) y DocumentDB/ElastiCache