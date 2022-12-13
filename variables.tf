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
        }
    ]
}

variable "vpc-name" {
    type = string
    description = "Custom VPC Name"
    default = "cicd-vpc"
}



# ----------------------------------------------------------------------------------------------------------------------
# CTD Required
# ----------------------------------------------------------------------------------------------------------------------
variable "project_id" {
  type        = string
  description = "project id required"
  default = "cicd-369521"
}

# variable "project_name" {
#  type        = string
#  description = "project name in which demo deploy"
# }

# variable "project_number" {
#  type        = string
#  description = "project number in which demo deploy"
# }
# variable "gcp_account_name" {
#  description = "user performing the demo"
# }
# variable "deployment_service_account_name" {
#  description = "Cloudbuild_Service_account having permission to deploy terraform resources"
# }
# variable "org_id" {
#  description = "Organization ID in which project created"
# }
# variable "data_location" {
#  type        = string
#  description = "Location of source data file in central bucket"
# }
# variable "secret_stored_project" {
#   type        = string
#   description = "Project where secret is accessing from"
# }