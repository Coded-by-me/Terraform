provider "google"{
    credentials = file(var.google_credentials_path)
    project = var.google_project_id
    region = var.google_region
    zone = var.google_zone
}