terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "vm" {
  name        = "vm${count.index}"
  platform_id = terraform.workspace == "prod" ? "standard-v2" : "standard-v1"
  count       = terraform.workspace == "prod" ? "2" : "1"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8smb7fj0o91i68s15v"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network01" {
  name = "network01"
}

resource "yandex_vpc_subnet" "subnet01" {
  name           = "subnet01"
  v4_cidr_blocks = ["10.2.0.0/16"]
  network_id     = yandex_vpc_network.network01.id
}



resource "yandex_compute_instance" "vm2" {
  for_each = {
    "vm01" = { name = "vm01" }
    "vm02" = { name = "vm02" }
  }
  platform_id = "standard-v1"
  lifecycle {
    create_before_destroy = true
  }
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8smb7fj0o91i68s15v"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
