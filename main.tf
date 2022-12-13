# ----------------------------------------------------------------------------------------------------------------------
# Steps 
# - Provision main services
# - Create Cloud Source Repository
# - Run Cloud Run with Sample Image
# - Make Cloud Trigger to Update Images
#
# ----------------------------------------------------------------------------------------------------------------------



# ----------------------------------------------------------------------------------------------------------------------
# Create Cloud Repo
# ----------------------------------------------------------------------------------------------------------------------

module "cloud_source_repo" {
  source  = "./modules/cloud_source_repo"
  project_id = var.project_id
}

# ----------------------------------------------------------------------------------------------------------------------
# Run Cloud Run Instance with Custom Image
# ----------------------------------------------------------------------------------------------------------------------
module "cloudrun" {
  source  = "./modules/run"
  project_id = var.project_id
  region = var.region
  docker-image = "us-docker.pkg.dev/cloudrun/container/hello"
}

# ----------------------------------------------------------------------------------------------------------------------
# Run GKE Instance with Custom Image
# ----------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "./modules/vpc"
  project_id = var.project_id
  regions = var.regions
  vpc-name = var.vpc-name
}


# Run GKE
module "gke" {
  source  = "./modules/gke"
  project_id = var.project_id
  regions = var.regions
  vpc-name = var.vpc-name  
  depends_on = [
    module.vpc
  ] 
}


# ----------------------------------------------------------------------------------------------------------------------
# Create Cloud Build Trigger That Deploys to Run and GKE
# ----------------------------------------------------------------------------------------------------------------------
module "cloud_build_trigger" {
  source  = "./modules/build_trigger"
  project_id = var.project_id
  repo_name =  module.cloud_source_repo.repo_name
  depends_on = [
    module.cloud_source_repo
  ]  
}

# ----------------------------------------------------------------------------------------------------------------------
# Run Cloud Build Trigger for Cloud Run
# ----------------------------------------------------------------------------------------------------------------------

# Timer for image
resource "time_sleep" "sleep_y" {
  create_duration = "120s"
}

resource "null_resource" "run_trigger" {
  provisioner "local-exec" {
    command = "gcloud beta builds triggers run run-trigger --branch=master"
  }
  depends_on = [
    time_sleep.sleep_y, module.cloudrun, module.cloud_build_trigger
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Run Cloud Build Trigger for GKE
# ----------------------------------------------------------------------------------------------------------------------



resource "null_resource" "gke_trigger" {
   provisioner "local-exec" {
   command = "gcloud beta builds triggers run gke-trigger --branch=master"
 }
  depends_on = [
    time_sleep.sleep_y, module.gke, module.cloud_build_trigger
  ]
}


# ----------------------------------------------------------------------------------------------------------------------
# Deploy to GCE -- Stretch Goal
# ----------------------------------------------------------------------------------------------------------------------

 
    # Run a startup script to install NGINX on GCE
    # Deploy files with / without containers

