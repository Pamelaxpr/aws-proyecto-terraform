
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