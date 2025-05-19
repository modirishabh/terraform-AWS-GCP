provider "google" {

  credentials = "../rishabhmodi-6fb570084be0.json"

  project = var.project
  region = var.region
  zone = var.zone
}

terraform {
    backend "gcs" {
        bucket = "holla_bahar_se"
        prefix = "holla1"
        credentials = "../rishabhmodi-6fb570084be0.json"
    } 
}

resource "google_compute_network" "vpc_network" {
  name = "new-terraform-network"
}
resource "google_compute_instance" "vm_instance" {
  name = "my-instancsaasasdae"
  machine_type = "f1-micro"  # Should be "f1-micro" not "f1.micro"
  metadata_startup_script = file("startup.sh")
  tags = ["web"]
  zone = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_address" "static_ip" {
    name = "terraform-static-ip"
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  target_tags = ["web"]
  source_ranges = ["0.0.0.0/0"]
}
