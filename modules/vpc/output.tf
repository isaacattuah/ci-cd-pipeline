output "vpc_id" {
  value = google_compute_network.demo-vpc.id
}
output "subnet_id" {
  value = google_compute_subnetwork.subnets
}
output "primary_region" {
  value = var.regions[0].region
}