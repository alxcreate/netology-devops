resource "yandex_compute_instance" "jenkins-master-01" {
  name                      = "jenkins-master-01"
  zone                      = "ru-central1-a"
  hostname                  = "jenkins-master-01.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4
  }
    metadata = {
    ssh-keys = "jenkins-master-01:${file("~/.ssh/id_rsa.pub")}"

  }


  boot_disk {
    initialize_params {
      image_id = "fd8151sv1q69mchl804a"
      name     = "root-jenkins-master-01"
      type     = "network-nvme"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }
}
