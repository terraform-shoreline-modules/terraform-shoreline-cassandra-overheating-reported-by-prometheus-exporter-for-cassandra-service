resource "shoreline_notebook" "overheating_reported_by_prometheus_exporter_at_labels_instance_for_cassandra_service" {
  name       = "overheating_reported_by_prometheus_exporter_at_labels_instance_for_cassandra_service"
  data       = file("${path.module}/data/overheating_reported_by_prometheus_exporter_at_labels_instance_for_cassandra_service.json")
  depends_on = [shoreline_action.invoke_prometheus_usage_check,shoreline_action.invoke_scale_up_deployment]
}

resource "shoreline_file" "prometheus_usage_check" {
  name             = "prometheus_usage_check"
  input_file       = "${path.module}/data/prometheus_usage_check.sh"
  md5              = filemd5("${path.module}/data/prometheus_usage_check.sh")
  description      = "The server hosting the Prometheus exporter may be overloaded with traffic, causing it to overheat and trigger the incident."
  destination_path = "/agent/scripts/prometheus_usage_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "scale_up_deployment" {
  name             = "scale_up_deployment"
  input_file       = "${path.module}/data/scale_up_deployment.sh"
  md5              = filemd5("${path.module}/data/scale_up_deployment.sh")
  description      = "If the overheating is caused by high traffic, consider scaling up the server or optimizing the Cassandra service to handle the load."
  destination_path = "/agent/scripts/scale_up_deployment.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_prometheus_usage_check" {
  name        = "invoke_prometheus_usage_check"
  description = "The server hosting the Prometheus exporter may be overloaded with traffic, causing it to overheat and trigger the incident."
  command     = "`chmod +x /agent/scripts/prometheus_usage_check.sh && /agent/scripts/prometheus_usage_check.sh`"
  params      = ["NAMESPACE","DEPLOYMENT_NAME"]
  file_deps   = ["prometheus_usage_check"]
  enabled     = true
  depends_on  = [shoreline_file.prometheus_usage_check]
}

resource "shoreline_action" "invoke_scale_up_deployment" {
  name        = "invoke_scale_up_deployment"
  description = "If the overheating is caused by high traffic, consider scaling up the server or optimizing the Cassandra service to handle the load."
  command     = "`chmod +x /agent/scripts/scale_up_deployment.sh && /agent/scripts/scale_up_deployment.sh`"
  params      = ["DESIRED_REPLICAS","NAMESPACE","DEPLOYMENT_NAME"]
  file_deps   = ["scale_up_deployment"]
  enabled     = true
  depends_on  = [shoreline_file.scale_up_deployment]
}

