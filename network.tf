resource "google_compute_network" "vpc_network" {
    name = "test-1"

    # 서브넷을 자동으로 생성할지에 대한 내용
    auto_create_subnetworks = false
    
    # MTU : Maximum Transmission Unit
    # 최대 패킷 크기(바이트 단위), 기본적으로 1460 바이트
    # 커지면, 데이터 양을 전송하는 데 필요한 패킷 수가 줄어들어, 효율 증가
    # 하지만, 네트워크 장비가 지원하는 MTU 크기보다 크게 설정하면, 패킷이 분할되어 전송되어, 성능 저하
    # 네트워크 장비가 지원하는 MTU 크기보다 작게 설정하면, 패킷이 분할되어 전송되어, 성능 저하
    # MTU 크기는 네트워크 장비마다 다르므로, 테스트를 통해 적절한 크기를 설정해야 함
    mtu = 1460 
}

resource "google_compute_subnetwork" "default" {
  # 서브넷 이름
  name          = "my-custom-subnet"

  # VPC의 CIDR 범위 내에서 서브넷의 CIDR 범위를 지정
  # /24 -> 11111111 11111111 11111111 00000000 -> 255.255.255.0으로 마스킹
  # -> 결국 255.255.255.1부터 254까지 사용 가능
  ip_cidr_range = "10.0.1.0/24"
  
  # 리전
  region        = var.google_region
  
  # 어떤 네트워크 인터페이스에 속할 지
  # 
  network       = google_compute_network.vpc_network.id
}