variable "repository_name" {
  description = "Name of the Google Cloud Source Repository."
  type        = string
  default     = "example-repo"
}

variable "project_id" {
  description = "The GCP project id"
  type        = string

}

variable "region" {
  
  description = "GCP region"
  type        = string
  default     = "us-central1" # Will be commented out in C2D
}

variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  ["sourcerepo.googleapis.com"]
        
}