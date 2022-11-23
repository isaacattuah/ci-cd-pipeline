# GCP Project Name
variable "project_id" {}
variable "regions" {}
variable "vpc-name" {}
# Extra GKE SA Roles
variable "gke_service_account_roles" {
    description = "GKE Service Account Roles"
    type        = list(string)
    default     = [
        "gkehub.connect",
        "gkehub.admin",
        "logging.logWriter",
        "monitoring.metricWriter",
        "monitoring.dashboardEditor",
        "stackdriver.resourceMetadata.writer",
        "opsconfigmonitoring.resourceMetadata.writer",
        "multiclusterservicediscovery.serviceAgent",
        "multiclusterservicediscovery.serviceAgent",
        "compute.networkViewer",
        "container.admin",
        "source.reader",
    ]
}
# GKE Settings
variable "gke-node-count" {
    description = "GKE Inital Node Count"
    type = number
    default = 2
}
variable "gke-node-type" {
    description = "GKE Node Machine Shape"
    type = string
    default = "e2-standard-2"
}
variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "container.googleapis.com",
        "gkehub.googleapis.com",
        "artifactregistry.googleapis.com"
    ]
}