provider "google" {
    credentials = file("terraform-474711-b8c12f017117.json")

    project = "terraform-474711"
    region  = "europe-west2"
    zone    = "europe-west2-c"
}

resource "google_compute_network" "vpc_network" {
    name                    = "practice-network"
    auto_create_subnetworks = true
}

terraform {
   required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0" # or whatever is latest
    }
  }

  backend "gcs" {
    bucket  = "main-terraform"
    prefix  = "terraform-practice"
    credentials = "terraform-474711-b8c12f017117.json"
  }
}
