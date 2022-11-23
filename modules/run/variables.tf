# GCP Project Name
variable "project_id" {}
variable "region" {}
variable "docker-image" {} # Assign to a value!
variable "service-name" {}
variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "run.googleapis.com",
        "iam.googleapis.com"
    ]
}
variable "cloud_run_iam_roles" {
    description = "Cloud Run Account Roles"
    type        = list(string)
    default     = [
       "stackdriver.resourceMetadata.writer" 
    ]
}