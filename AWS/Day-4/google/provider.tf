 terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.15.0"
    }
  }
}

provider "google" {
  credentials = "/home/rishabh/.config/gcloud/application_default_credentials.json"
  project = "whizhack-project"
  region = "us-central1"
  }
