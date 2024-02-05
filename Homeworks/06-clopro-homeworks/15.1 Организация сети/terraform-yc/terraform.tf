# Provider
terraform {
  required_providers {
    yandex   = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "b1g6f9ktskg20km27fo6"
  folder_id = "b1gepbnbb1dpav5bstcs"
}

# Create vpc
resource "yandex_vpc_network" "netology_vpc" {
  name = "netology-vpc"
}

# Create public subnet
resource "yandex_vpc_subnet" "public_subnet" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology_vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "nat_instance" {
  name        = "nat-instance"
  zone        = "ru-central1-a"

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public_subnet.id
    ip_address = "192.168.10.254"
    nat        = true
  }

  resources {
    cores  = 2
    memory = 2
  }
}


# Create public VM
resource "yandex_compute_instance" "public_instance" {
  name           = "public-instance"
  zone           = "ru-central1-a"
  platform_id    = "standard-v1"
  boot_disk {
    initialize_params {
      image_id = "fd8tf1sepeiku6d37l4l" # ubuntu-2204-lts
    }
  }
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public_subnet.id
    nat = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Create private subnet
resource "yandex_vpc_subnet" "private_subnet" {
  name           = "private-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.netology_vpc.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_route_table.id
}

# Create route table
resource "yandex_vpc_route_table" "private_route_table" {
  network_id = yandex_vpc_network.netology_vpc.id

  static_route {
    destination_prefix  = "0.0.0.0/0"
    next_hop_address    = "192.168.10.254"
  }
}

# Create private VM
resource "yandex_compute_instance" "private_instance" {
  name           = "private-instance"
  zone           = "ru-central1-a"
  platform_id    = "standard-v1"
  boot_disk {
    initialize_params {
      image_id = "fd8tf1sepeiku6d37l4l" # ubuntu-2204-lts
    }
  }
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private_subnet.id
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "external_ip_address_public_instance_yandex_cloud" {
  value = yandex_compute_instance.public_instance.network_interface.0.nat_ip_address
}
output "internal_ip_address_private_instance_yandex_cloud" {
  value = yandex_compute_instance.private_instance.network_interface.0.ip_address
}
