terraform {
  required_version = ">= 1.1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.42.1"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "~> 4.42.1"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.7.2"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.3.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }      
  }
}