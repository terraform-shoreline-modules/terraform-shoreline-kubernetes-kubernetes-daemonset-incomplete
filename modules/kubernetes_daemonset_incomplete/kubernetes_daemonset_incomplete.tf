resource "shoreline_notebook" "kubernetes_daemonset_incomplete" {
  name       = "kubernetes_daemonset_incomplete"
  data       = file("${path.module}/data/kubernetes_daemonset_incomplete.json")
  depends_on = [shoreline_action.invoke_pod_template_check,shoreline_action.invoke_resource_limits]
}

resource "shoreline_file" "pod_template_check" {
  name             = "pod_template_check"
  input_file       = "${path.module}/data/pod_template_check.sh"
  md5              = filemd5("${path.module}/data/pod_template_check.sh")
  description      = "The pod spec in the DaemonSet configuration could be incorrect or incomplete."
  destination_path = "/agent/scripts/pod_template_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "resource_limits" {
  name             = "resource_limits"
  input_file       = "${path.module}/data/resource_limits.sh"
  md5              = filemd5("${path.module}/data/resource_limits.sh")
  description      = "Review the Kubernetes resource limits for the daemonset and adjust as necessary."
  destination_path = "/agent/scripts/resource_limits.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_pod_template_check" {
  name        = "invoke_pod_template_check"
  description = "The pod spec in the DaemonSet configuration could be incorrect or incomplete."
  command     = "`chmod +x /agent/scripts/pod_template_check.sh && /agent/scripts/pod_template_check.sh`"
  params      = ["NAMESPACE","DAEMONSET_NAME"]
  file_deps   = ["pod_template_check"]
  enabled     = true
  depends_on  = [shoreline_file.pod_template_check]
}

resource "shoreline_action" "invoke_resource_limits" {
  name        = "invoke_resource_limits"
  description = "Review the Kubernetes resource limits for the daemonset and adjust as necessary."
  command     = "`chmod +x /agent/scripts/resource_limits.sh && /agent/scripts/resource_limits.sh`"
  params      = ["NAMESPACE","DAEMONSET_NAME"]
  file_deps   = ["resource_limits"]
  enabled     = true
  depends_on  = [shoreline_file.resource_limits]
}

