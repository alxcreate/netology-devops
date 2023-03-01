resource "yandex_compute_instance" "teamcity-agent" {
  name                      = "teamcity-agent"
  zone                      = "ru-central1-a"
  hostname                  = "teamcity-agent.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }
    metadata = {
    ssh-keys = "teamcity-agent:${file("~/.ssh/id_rsa.pub")}"

  }

  boot_disk {
    initialize_params {
      image_id = "fd8151sv1q69mchl804a"
      name     = "root-teamcity-agent"
      type     = "network-nvme"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }
}
