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



# Build Cloud Build Trigger for Run
resource "google_cloudbuild_trigger" "cloud_build_trigger_run" {
  provider    = google-beta
# description = "Cloud Source Repository Trigger ${var.repo_name.name} (${var.branch_name})"
  description = "run-trigger"
  project = var.project_id  

  trigger_template {
    branch_name = var.branch_name
    repo_name   = var.repo_name.name
  }

  
  filename = "cloudbuildrun.yaml"
  ignored_files = ["cloudbuildgce.yaml","cloudbuildgke.yaml","deployment.yaml"]
  service_account = google_service_account.cloudbuild_service_account.id
  depends_on = [google_project_iam_member.cloudbuild_roles]
}

# Build Cloud Build Trigger for Run
resource "google_cloudbuild_trigger" "cloud_build_trigger_gke" {
  provider    = google-beta
# description = "Cloud Source Repository Trigger ${var.repo_name.name} (${var.branch_name})"
  description = "gke-trigger"
  project = var.project_id  

  trigger_template {
    branch_name = var.branch_name
    repo_name   = var.repo_name.name
  }

  
  filename = "cloudbuildgke.yaml"
  ignored_files = ["cloudbuildgce.yaml","cloudbuildrun.yaml","deployment.yaml"]
  service_account = google_service_account.cloudbuild_service_account.id
  depends_on = [google_project_iam_member.cloudbuild_roles]
}

# Launch Cloud Build Trigger Service Account
resource "google_service_account" "cloudbuild_service_account" {
  account_id = "my-service-account"
}

# Custom Role for storage.object.get

resource "google_project_iam_custom_role" "push-gcr" {
  role_id     = "push_gcr"
  title       = "GCR Push"
  description = "Role that pushes to GCR"
  permissions = ["storage.buckets.get","storage.objects.get"]
}

resource "google_project_iam_member" "cloudbuild_roles" {
  depends_on = [google_project_iam_custom_role.push-gcr, google_service_account.cloudbuild_service_account]
  for_each   = toset(["roles/run.admin", "roles/iam.serviceAccountUser", "roles/logging.logWriter", "roles/source.admin", "projects/${var.project_id}/roles/${google_project_iam_custom_role.push-gcr.role_id}", "roles/storage.objectAdmin", "roles/iam.serviceAccountTokenCreator","roles/container.developer"])
  project    = var.project_id
  role       = each.key
  member      = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

# resource "null_resource" "run_trigger" {
#   provisioner "local-exec" {
#     command = "gcloud beta builds triggers run run-trigger --branch=master"
#   }
#   depends_on = [
#     google_cloudbuild_trigger.cloud_build_trigger
#   ]
# }

 
# Deploy to Cloud Run
# locals {
#   image = "gcr.io/${var.project_id}/pos:v1.1"
# }


# module "cloudrun" {
#   source  = "../run"
#   project_id = var.project_id
#   region = var.region
#   docker-image = local.image
#   depends_on = [google_cloud_scheduler_job.cloud_scheduler_job]
# }

# # Configuring VPC 
# module "vpc" {
#   source  = "../vpc"
#   project_id = var.project_id
#   regions = var.regions
#   vpc-name = var.vpc-name
# }


# ----------------------------------------------------------------------------------------------------------------------
# Deploy Docker Image to GKE
# ----------------------------------------------------------------------------------------------------------------------

# Make GKE cluster in VPC
# module "gke" {
#   source  = "../gke"
#   project_id = var.project_id
#   regions = var.regions
#   vpc-name = var.vpc-name
  
#   depends_on = [
#     module.vpc
#   ]
# }

# # Expose services with yaml files
# resource "null_resource" "expose_pods" {

# # Use Trigger
#  provisioner "local-exec" {
#    command = <<EOF
# kubectl apply -f service.yaml
# kubectl get services
# EOF
#  }
# depends_on = [
#  module.gke
# ]

# }