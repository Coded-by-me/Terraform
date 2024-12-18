# Google Cloud Provider 설정
provider "google"{
    # tfvars를 사용해서, 변수를 설정할 수 있음.
    credentials = file(var.google_credentials_path)
    project = var.google_project_id
    region = var.google_region
    zone = var.google_zone
}