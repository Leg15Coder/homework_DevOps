terraform {
  required_version = ">= 1.0.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "devops_net" {
  name = "devops-isolated-net"
}

resource "docker_container" "devops_sandbox" {
  image    = "ubuntu:22.04"
  name     = "devops-target-sandbox"
  must_run = true
  command  = ["sleep", "infinity"]

  networks_advanced {
    name = docker_network.devops_net.name
  }
}

output "sandbox_container_name" {
  value       = docker_container.devops_sandbox.name
  description = "Имя созданного локального хоста"
}
