resource "google_compute_instance" "default" {
    name = "test-instance"
    machine_type = "f1-micro"
    zone = "asia-northeast3-a"
    tags = ["ssh"]

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }

    metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential git; echo 'Hello, World!' > test.txt"

    network_interface {
        subnetwork = google_compute_subnetwork.default.id

        access_config{

        }
    }
}