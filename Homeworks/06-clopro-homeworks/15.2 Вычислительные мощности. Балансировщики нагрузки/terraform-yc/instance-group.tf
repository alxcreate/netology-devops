resource "yandex_compute_instance_group" "lamp_instance_group" {
  name               = "lamp-instance-group"
  service_account_id = var.service_account_id
  folder_id          = var.folder_id

  instance_template {
    platform_id = "standard-v1"
    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
      user-data = "#!/bin/bash\n echo \"<html><head><title>Start Page</title></head><body><h1>Welcome to My Website</h1><img src='https://${yandex_storage_bucket.netology-bucket-wfghad.bucket_domain_name}/${yandex_storage_object.iceberg.key}'></body></html>\" > /var/www/html/index.html"
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    resources {
      cores  = 2
      memory = 2
    }

    network_interface {
      nat        = true
      network_id = yandex_vpc_network.netology_network.id
      subnet_ids = ["${yandex_vpc_subnet.public_subnet.id}"]
    }
  }

  scale_policy {
    fixed_scale {
      size = 3 # Количество ВМ в группе
    }
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  health_check {
    tcp_options {
      port = 80
    }
    interval            = 10 # Интервал проверки состояния ВМ в секундах
    timeout             = 5  # Время ожидания ответа от ВМ в секундах
    unhealthy_threshold = 3  # Количество неудачных попыток до пометки ВМ как нездоровой
  }
  load_balancer {
    target_group_name = "netology-lb"
  }
}
