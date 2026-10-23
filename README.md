
# 🚀 Proyecto: Migración a AWS ECS Fargate con Terraform (Entorno Local)

Este proyecto es una Prueba de Concepto (PoC) técnica para aprovisionar una infraestructura IoT de Telemática de vehículos (basada en microservicios) utilizando **AWS ECS Fargate**.

La infraestructura se ha desplegado íntegramente mediante **Terraform**, utilizando **Floci (LocalStack)** para simular el panel de control y las APIs de AWS en un entorno local sin incurrir en costes de nube.

## 🗺️ Mapa de Ruta del Proyecto que he seguido

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

- [x] **Fase 6: Tareas Fargate y Servicios**
  - Archivos: `tasks.tf` y `services.tf`
  - Qué hará: Desplegar los 4 microservicios dentro del clúster conectándolos entre sí.


## 📂 Estructura del Proyecto

Para esta PoC, se ha utilizado una estructura plana enfocada en la separación lógica de los recursos de infraestructura:

```text
aws-proyecto-terraform/
├── provider.tf      # Configuración del proveedor AWS y endpoints locales de Floci 
|                      (ec2,   ecr, ecs, elbv2)
├── variables.tf     # Variables globales (nombre del proyecto, bloque CIDR)
├── vpc.tf           # Red privada (VPC), 2 subredes públicas (Multi-AZ), 2 privadas e IGW
├── ecr.tf           # Repositorios de imágenes Docker para microservicios
├── ecs.tf           # Clúster ECS con proveedor de capacidad Fargate
├── security.tf      # Grupos de seguridad (ALB abierto a internet, contenedores aislados)
├── alb.tf           # Application Load Balancer, Target Group y Listener HTTP
├── services.tf      # Definición de Tarea (Task) y Servicio ECS (usando Nginx como simulador de API)
├── outputs.tf       # Salidas de Terraform (URLs de ECR, DNS del balanceador, IDs)
└── .gitignore       # Archivos de estado de Terraform excluidos del control de versiones

## ⚙️ Cómo ejecutar este proyecto en local

1. Asegúrate de tener Floci ejecutándose en tu ordenador.
2. Clona este repositorio y abre una terminal.
3. Ejecuta `terraform init` para descargar los proveedores.
4. Ejecuta `terraform apply` y escribe `yes` para construir la infraestructura.
