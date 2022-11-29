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


# Build Cloud Build Trigger
resource "google_cloudbuild_trigger" "cloud_build_trigger" {
  provider    = google-beta
  description = "Cloud Source Repository Trigger ${var.repo_name.name} (${var.branch_name})"
  project = var.project_id  

  trigger_template {
    branch_name = var.branch_name
    repo_name   = var.repo_name.name
  }

  
  filename = "cloudbuild.yaml"
  service_account = google_service_account.cloudbuild_service_account.id
  depends_on = [time_sleep.sleep_x, google_service_account.cloudbuild_service_account]
}


# Launch Cloud Build Trigger Service Account
resource "google_service_account" "cloudbuild_service_account" {
  account_id = "my-service-account"
}

resource "google_project_iam_member" "cloudbuild_roles" {
  depends_on = [google_cloudbuild_trigger.cloud_build_trigger]
  for_each   = toset(["roles/run.admin", "roles/iam.serviceAccountUser"])
  project    = var.project_id
  role       = each.key
  member      = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}


# Deploy to Cloud Run
locals {
  image = "gcr.io/${var.project_id}/pos:v1.1"
}

module "cloudrun" {
  source  = "../run"
  project_id = var.project_id
  region = var.region
  docker-image = local.image
  depends_on = [google_project_iam_member.cloudbuild_roles]
}



# Deploy to GKE