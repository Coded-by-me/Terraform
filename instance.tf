resource "google_compute_instance" "default" {
    name = "test-instance"
    machine_type = "f1-micro"
    zone = var.google_zone
    allow_stopping_for_update = true
    tags = ["ssh"]

    boot_disk {
        # VM Instance 이미지 지정
        initialize_params {
            image  = "ubuntu-os-cloud/ubuntu-2004-lts"
            size   = 25  # 25 GB disk size
            type   = "pd-balanced"
        }
    }

    metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential git; echo 'Hello, World!' > test.txt"

    network_interface {
        subnetwork = google_compute_subnetwork.default.id

        access_config{

        }
    }
}