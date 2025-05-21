resource "google_compute_network" "vpc_network" {
  project                 = "whizhack-project"
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "vpc-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  project       = "whizhack-project"
}

