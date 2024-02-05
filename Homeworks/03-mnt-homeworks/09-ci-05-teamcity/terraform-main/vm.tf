resource "yandex_compute_instance" "vm" {
  name                      = "vm"
  zone                      = "ru-central1-a"
  hostname                  = "vm.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }
  metadata = {
    ssh-keys = "vm:${file("~/.ssh/id_rsa.pub")}"

  }

  boot_disk {
    initialize_params {
      image_id = "fd8jvcoeij6u9se84dt5"
      name     = "root-vm"
      type     = "network-nvme"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }
}
