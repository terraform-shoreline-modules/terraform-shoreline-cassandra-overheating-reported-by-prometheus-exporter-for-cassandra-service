terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "overheating_reported_by_prometheus_exporter_at_labels_instance_for_cassandra_service" {
  source    = "./modules/overheating_reported_by_prometheus_exporter_at_labels_instance_for_cassandra_service"

  providers = {
    shoreline = shoreline
  }
}