output "vpc_id" {
  value = aws_vpc.main.id
}

output "ecs_cluster_name" {
  description = "Nombre exacto del Cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecr_repositories_urls" {
  description = "URLs exactas de los repositorios para subir las imágenes Docker"
  value = {
    for name, repo in aws_ecr_repository.microservices : name => repo.repository_url
  }

output "alb_dns_name" {
  description = "URL publica del Balanceador de Carga"
  value       = aws_lb.main.dns_name
} 

}