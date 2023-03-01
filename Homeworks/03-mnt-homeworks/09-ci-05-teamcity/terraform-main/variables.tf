# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1g6f9ktskg20km27fo6"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gepbnbb1dpav5bstcs"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
  default = "fd8jvcoeij6u9se84dt5"
}

variable "ubuntu-2204-base" {
  default = "fd8ueg1g3ifoelgdaqhb"
}

variable "centos-8-base" {
  default = "fd8151sv1q69mchl804a"
}

variable "container-optimized-image" {
  default = "fd80o2eikcn22b229tsa"
}
