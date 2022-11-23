# ----------------------------------------------------------------------------------------------------------------------
# CREATE VPC & Subnets
# ----------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
# Enable APIs
# ----------------------------------------------------------------------------------------------------------------------
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
resource "google_compute_router" "primary" {
  for_each = google_compute_subnetwork.subnets
  name    = "${each.value.region}-router"
  region  = "${each.value.region}"
  network = google_compute_network.demo-vpc.id
  bgp {
    asn = 64514
  }
  depends_on = [
    google_compute_subnetwork.subnets
    ]
}
resource "google_compute_router_nat" "nat" {
  for_each = google_compute_router.primary
  name                               = "${each.value.region}-nat"
  router                             = "${each.value.name}"
  region                             = "${each.value.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  depends_on = [
    google_compute_router.primary
    ]
}