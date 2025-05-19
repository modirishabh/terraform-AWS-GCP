provider "google" {
    credentials = file("rishabhmodi-6fb570084be0.json")
    project = "rishabhmodi"
    region  = "us-central1"
    zone = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
    name = "terraform-network"
}

terraform {
    backend "gcs" {
        bucket = "holla_bahar_se"
        prefix = "holla1"
        credentials = "rishabhmodi-6fb570084be0.json"
    } 
}

resource "google_compute_instance" "vm_instance" {
    name         = "terraform-instance"
    machine_type = "f1-micro"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-9"
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
