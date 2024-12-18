resource "google_compute_network" "vpc_network" {
    name = "test-1"
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
  name          = "my-custom-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-northeast3"
  network       = google_compute_network.vpc_network.id
}