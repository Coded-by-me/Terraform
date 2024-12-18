# resource <provider>_<resource_type> <resource_name> 
# resource name은 일종의 변수명으로, 해당 리소스의 이름을 지정하는 것이다.
# backend, infra 등 여러 개의 리소스를 지정할 수 있음
resource "google_compute_instance" "default" {

    # 인스턴스 이름
    name = "test-instance"
    
    # 해당 인스턴스의 타입
    machine_type = "f1-micro"

    zone = var.google_zone
    
    # 인스턴스가 중지되어도 업데이트를 허용할지 여부
    allow_stopping_for_update = true
    
    # 인스턴스에 부여할 태그
    tags = ["ssh"]

    boot_disk {
        # VM Instance 이미지 지정
        initialize_params {
            image  = "ubuntu-os-cloud/ubuntu-2004-lts"
            # 25 GB disk size
            # 기본적으로 os 이미지의 사이즈는 5GB가량
            # 부팅 이미지를 설치하고 남는 잉여 디스크는 사용 가능한 용량으로 전환
            # 별도의 디스크를 attach하고 싶다면, 별도의 디스크를 생성하고, attach해야함
            size   = 25  
            type   = "pd-balanced"
        }
    }

    # VM Instance에 부팅 시 실행할 스크립트
    # git clone을 통해서, 필요한 소스코드나 jar를 통해서 간단하게 실행 가능
    metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential git; echo 'Hello, World!' > test.txt"

    # VM Instance에 할당할 네트워크 인터페이스
    ## 이전에 선언한 network를 사용함.
    ## terraform에서는 resource간 의존성을 자동으로 파악하여, 자동으로 생성 순서를 정함.
    network_interface {
        subnetwork = google_compute_subnetwork.default.id

        access_config{

        }
    }
}