provider "google" {
  project = "checkin-436517"
  region  = "us-central1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "dashathvm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Change OS if needed
    }
  }

  network_interface {
    network = "default"

    access_config {
      # Assigns a public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl start nginx
  EOT

  tags = ["web", "http-server"]
}

output "instance_name" {
  value = google_compute_instance.vm_instance.name
}

output "public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
