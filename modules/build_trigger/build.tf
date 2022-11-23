# Enable APIs
resource "google_project_service" "enabled_service" {
  for_each = toset(var.services_to_enable)
  project  = var.project_id
  service  = each.key

}
resource "time_sleep" "sleep_x" {
  create_duration = "30s"
  depends_on = [
    google_project_service.enabled_service
  ]
}

resource "google_cloudbuild_trigger" "cloud_build_trigger" {
  provider    = google-beta
  description = "Cloud Source Repository Trigger ${var.repo_name.name} (${var.branch_name})"
  project = var.project_id  

  trigger_template {
    branch_name = var.branch_name
    repo_name   = var.repo_name.name
  }

  
  filename = "cloudbuild.yaml"
  depends_on = [time_sleep.sleep_x]
}