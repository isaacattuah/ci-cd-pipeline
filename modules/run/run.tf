# ----------------------------------------------------------------------------------------------------------------------
# Cloud Run
# ----------------------------------------------------------------------------------------------------------------------
# Enable APIs
resource "google_project_service" "enable-services" {
  for_each = toset(var.services_to_enable)
  project = var.project_id
  service = each.value
  disable_on_destroy = false
}
# Create Cloud Run Service
resource "google_cloud_run_service" "default" {
  project = var.project_id
  name     = var.service-name
  location = var.region
  template {
    spec {
      containers {
        image = var.docker-image
      }
      service_account_name = google_service_account.cloud-run-sa.email
    }
  }
  depends_on = [
    google_project_service.enable-services,
    google_service_account.cloud-run-sa
  ]
}
# Enable Anon Access
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "noauth" {
    location    = google_cloud_run_service.default.location
    project     = google_cloud_run_service.default.project
    service     = google_cloud_run_service.default.name
    policy_data = data.google_iam_policy.noauth.policy_data
    depends_on = [
        google_cloud_run_service.default,
        google_project_service.enable-services
    ]
}