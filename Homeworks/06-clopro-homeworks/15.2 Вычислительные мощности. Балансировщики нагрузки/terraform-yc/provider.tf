terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

variable "cloud_id" {}
variable "folder_id" {}
variable "service_account_id" {}
variable "access_key" {}
variable "secret_key" {}
