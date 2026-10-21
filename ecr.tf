# ecr.tf

locals {
  microservices = [
    "telematics-ingestion",
    "telematics-mapping",
    "telematics-events",
    "telematics-api"
  ]
}

resource "aws_ecr_repository" "microservices" {
  for_each             = toset(local.microservices)
  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = each.key
  }
}