resource "yandex_kubernetes_cluster" "kubernetes-cluster" {
  network_id = yandex_vpc_network.vpc-network.id
  master {
    regional {
      region = "ru-central1"
      location {
        zone      = yandex_vpc_subnet.subnet-a2.zone
        subnet_id = yandex_vpc_subnet.subnet-a2.id
      }
      location {
        zone      = yandex_vpc_subnet.subnet-b2.zone
        subnet_id = yandex_vpc_subnet.subnet-b2.id
      }
      location {
        zone      = yandex_vpc_subnet.subnet-c2.zone
        subnet_id = yandex_vpc_subnet.subnet-c2.id
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

resource "yandex_kubernetes_node_group" "kubernetes-nodes" {
  cluster_id = yandex_kubernetes_cluster.kubernetes-cluster.id
  name       = "kubernetes-nodes"
  allocation_policy {
    location {
      zone      = yandex_vpc_subnet.subnet-a2.zone
      subnet_id = yandex_vpc_subnet.subnet-a2.id
    }
  }
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores = 2
    }
    container_runtime {
      type = "containerd"
    }
  }
  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }
}

resource "yandex_iam_service_account" "sa-kubernetes" {
  name        = "sa-kubernetes"
  description = "Service account for kubernetes cluster"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kubernetes.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-kubernetes.id}"
}

resource "yandex_kms_symmetric_key" "kms-key-kubernetes" {
  name              = "kms-key-kubernetes"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год
}
