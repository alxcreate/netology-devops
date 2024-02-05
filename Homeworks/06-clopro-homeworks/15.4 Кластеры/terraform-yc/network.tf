resource "yandex_vpc_network" "vpc-network" {
  name = "vpc-network"
}
# Subnets for mysql
resource "yandex_vpc_subnet" "subnet-a1" {
  name           = "subnet-a1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-network.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b1" {
  name           = "subnet-b1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc-network.id
  v4_cidr_blocks = ["192.168.2.0/24"]
}

resource "yandex_vpc_subnet" "subnet-c1" {
  name           = "subnet-c1"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.vpc-network.id
  v4_cidr_blocks = ["192.168.3.0/24"]
}
# Subnets for kubernetes
resource "yandex_vpc_subnet" "subnet-a2" {
  name           = "subnet-a2"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b2" {
  name           = "subnet-b2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc-network.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}

resource "yandex_vpc_subnet" "subnet-c2" {
  name           = "subnet-c2"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.vpc-network.id
  v4_cidr_blocks = ["192.168.13.0/24"]
}
