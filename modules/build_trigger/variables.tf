variable "project_id" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "repo_name"{
}

variable "region" {
  type    = string
  description = "Region to run cloud run"
  default = "us-central1"
}

variable "regions" { 
    type = list(object({
        region = string
        cidr = string
        zone = string
        management-cidr = string
        })
    )
    default = [{
            region = "us-central1"
            cidr = "10.0.0.0/24"
            zone = "us-central1-a"
            management-cidr = "192.168.1.0/28"
        },
        {
            region = "us-east1"
            cidr = "10.0.1.0/24"
            zone = "us-east1-b"
            management-cidr = "192.168.1.16/28"
        }
    ]
}

variable "vpc-name" {
    type = string
    description = "Custom VPC Name"
    default = "cicd-golden-demo-vpc"
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
    "iam.googleapis.com"
  ]
        
}