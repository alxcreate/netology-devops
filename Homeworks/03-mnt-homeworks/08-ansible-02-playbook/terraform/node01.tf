resource "yandex_compute_instance" "clickhouse-01" {
  name                      = "clickhouse-01"
  zone                      = "ru-central1-a"
  hostname                  = "clickhouse-01.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 8
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = var.centos-8-base
      name     = "root-clickhouse-01"
      type     = "network-nvme"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
