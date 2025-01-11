resource "google_compute_firewall" "default" {
    name = "default-allow-firewall"
    network = google_compute_network.vpc_network.name

    allow {
        protocol = "tcp"
        ports = ["22"] # ssh port
    }

    direction = "INGRESS"
    priority = 1000
    target_tags = ["ssh"]
    source_ranges = ["0.0.0.0/0"]
}