# GCP Project Name
variable "project_id" {}
variable "vpc-name" {}
# List of regions (support for multi-region deployment)
# variable "regions" {}
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

variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "compute.googleapis.com",
        "iam.googleapis.com",
        "logging.googleapis.com",
        "monitoring.googleapis.com",
        "opsconfigmonitoring.googleapis.com",
        "serviceusage.googleapis.com",
        "stackdriver.googleapis.com",
        "servicemanagement.googleapis.com",
        "servicecontrol.googleapis.com",
        "networkmanagement.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "trafficdirector.googleapis.com",
        "dns.googleapis.com",
        "servicenetworking.googleapis.com",
        "firewallinsights.googleapis.com"
    ]
}