# google credential이 저장된 절대 경로
variable google_credentials_path{
    description = "The path to the Google Cloud Platform credentials file"
}

# 인스턴스를 생성할 프로젝트의 id
## !주의! : 프로젝트의 이름이 아니라, 옆에있는 id 값을 입력해야함
variable google_project_id{
    description = "The project ID to deploy resources"
}

# 인스턴스를 생성할 리전
variable google_region{
    description = "The region to deploy resources"
}

# 인스턴스를 생성할 리전 내의 지역
variable google_zone{
    description = "The zone to deploy resources"
}