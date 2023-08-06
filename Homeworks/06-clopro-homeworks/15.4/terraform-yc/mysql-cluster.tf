resource "yandex_mdb_mysql_cluster" "mysql-cluster" {
  name        = "mysql-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.vpc-network.id
  version     = "8.0"
  backup_window_start {
    hours   = 23
    minutes = 59
  }
  deletion_protection = true

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  database {
    name = "netology_db"
  }

  user {
    name     = "sa"
    password = "netology"
    permission {
      database_name = "netology_db"
      roles         = ["ALL"]
    }
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet-a1.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.subnet-b1.id
  }

  host {
    zone      = "ru-central1-c"
    subnet_id = yandex_vpc_subnet.subnet-c1.id
  }
}
