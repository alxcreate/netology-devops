resource "yandex_vpc_network" "netology_network" {
  name = "netology-network"
}

resource "yandex_vpc_subnet" "public_subnet" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_network_load_balancer" "netology-lb" {
  name = "netology-lb"

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp_instance_group.load_balancer.0.target_group_id

    healthcheck {
      name                = "web"
      interval            = 10
      timeout             = 5
      unhealthy_threshold = 3
      tcp_options {
        port = 80
      }
    }
  }
  listener {
    name = "netology-lb-listener-http"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  listener {
    name = "netology-lb-listener-https"
    port = 443
    external_address_spec {
      ip_version = "ipv4"
    }
  }
}

output "yandex_lb_network_load_balancer" {
  value = yandex_lb_network_load_balancer.netology-lb.listener.*.external_address_spec[0].*.address
}
