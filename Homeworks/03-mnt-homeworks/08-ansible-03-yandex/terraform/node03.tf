resource "yandex_compute_instance" "lighthouse" {
  name                      = "lighthouse"
  zone                      = "ru-central1-a"
  hostname                  = "lighthouse.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = var.centos-8-base
      name     = "root-lighthouse"
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
