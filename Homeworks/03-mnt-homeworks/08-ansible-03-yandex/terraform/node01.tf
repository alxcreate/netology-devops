resource "yandex_compute_instance" "clickhouse" {
  name                      = "clickhouse"
  zone                      = "ru-central1-a"
  hostname                  = "clickhouse.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.centos-8-base
      name     = "root-clickhouse"
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
