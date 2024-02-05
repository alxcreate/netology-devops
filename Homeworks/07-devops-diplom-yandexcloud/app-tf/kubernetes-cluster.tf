resource "yandex_kubernetes_cluster" "kubernetes-cluster" {
  network_id = yandex_vpc_network.vpc-network.id
  master {
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.subnet-a.zone
        subnet_id = yandex_vpc_subnet.subnet-a.id
      }
      location {
        zone      = yandex_vpc_subnet.subnet-b.zone
        subnet_id = yandex_vpc_subnet.subnet-b.id
      }
      location {
        zone      = yandex_vpc_subnet.subnet-c.zone
        subnet_id = yandex_vpc_subnet.subnet-c.id
      }
    }
    public_ip = true
  }
  service_account_id      = yandex_iam_service_account.sa-kubernetes.id
  node_service_account_id = yandex_iam_service_account.sa-kubernetes.id
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key-kubernetes.id
  }
  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor,
    yandex_resourcemanager_folder_iam_member.images-puller
  ]
}
# Группа нод в subnet-a1
resource "yandex_kubernetes_node_group" "kubernetes-nodes-a" {
  cluster_id = yandex_kubernetes_cluster.kubernetes-cluster.id
  name       = "kubernetes-group-a"
  allocation_policy {
    location {
      zone = yandex_vpc_subnet.subnet-a.zone
    }
  }
  instance_template {
    platform_id = "standard-v1"
    name = "kubernetes-node-a-{instance.short_id}"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet-a.id}"]
    }
    resources {
      cores = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }
    container_runtime {
      type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}
# Группа нод в subnet-b1
resource "yandex_kubernetes_node_group" "kubernetes-nodes-b" {
  cluster_id = yandex_kubernetes_cluster.kubernetes-cluster.id
  name       = "kubernetes-nodes-b"
  allocation_policy {
    location {
      zone = yandex_vpc_subnet.subnet-b.zone
    }
  }
  instance_template {
    platform_id = "standard-v1"
    name = "kubernetes-node-b-{instance.short_id}"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet-b.id}"]
    }
    resources {
      cores = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }
    container_runtime {
      type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}
# Группа нод в subnet-c1
resource "yandex_kubernetes_node_group" "kubernetes-nodes-c" {
  cluster_id = yandex_kubernetes_cluster.kubernetes-cluster.id
  name       = "kubernetes-group-c"
  allocation_policy {
    location {
      zone = yandex_vpc_subnet.subnet-c.zone
    }
  }
  instance_template {
    platform_id = "standard-v1"
    name = "kubernetes-node-c-{instance.short_id}"
    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet-c.id}"]
    }
    resources {
      cores = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }
    container_runtime {
      type = "containerd"
    }
  }
  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}

resource "yandex_iam_service_account" "sa-kubernetes" {
  name        = "sa-kubernetes"
  description = "Service account for kubernetes cluster"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kubernetes.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.yc_folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kubernetes.id}"
}

resource "yandex_kms_symmetric_key" "kms-key-kubernetes" {
  name              = "kms-key-kubernetes"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год
}
