resource "google_project_service" "enable-services" {
  for_each = toset(var.services_to_enable)
  project = var.project_id
  service = each.value
  disable_on_destroy = false
}
resource "google_compute_network" "demo-vpc" {
  name = var.vpc-name                   
  auto_create_subnetworks = false
  depends_on = [
    google_project_service.enable-services
  ]
}
resource "google_compute_subnetwork" "subnets" {
  for_each = {for a_subnet in var.regions: a_subnet.region => a_subnet}
  name = "${each.value.region}"
  ip_cidr_range =  "${each.value.cidr}"       
  region        = "${each.value.region}"
  network       = google_compute_network.demo-vpc.id
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  
  depends_on = [
    google_compute_network.demo-vpc
    ]
}
