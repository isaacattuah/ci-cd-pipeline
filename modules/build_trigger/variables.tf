variable "project_id" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "repo_name"{
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1" # Will be commented out in C2D
}

variable "gcr_region" {
  description = "Name of the GCP region where the GCR registry is located."
  type        = string
  default     = "us"
}

variable "branch_name" {
  description = "Example branch name used to trigger builds."
  type        = string
  default     = "master"
}

variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "iam.googleapis.com",
  ]
        
}