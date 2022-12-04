# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws.

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше.


## Задача 2. Инициализируем проект и создаем воркспейсы.

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два.
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

### Ответ:

Вывод команды `terraform workspace list`:
```sh
alx@alx-laptop terraform % terraform workspace list       
  default
* prod
  stage
```

Вывод команды `terraform plan` для воркспейса `prod`:
```sh
alx@alx-laptop terraform % terraform plan

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD3R9Y4b0XAtt4uh0TYmWM+OVMHNuHEljZLMMSfPEt/NDgLL9b60GF9YTTIMy8t9PJEo0dFU+Pw8Xqe8PSVqmCPMOEC/vEhfViayYFFC8ntDdFyt8wn4NntKQYX5etRTssWiq7D1lhVhK5rkpJeXhjguJZGT0NexOU0nKVYQj0PuSK5UlZUeMQa7b8V/4N8EsfAK6iOV+3iEafcrYYkgysN+fVB0DZT4YPlPXxIN+eXpKVfNYC9TXyhz8pX1VNoBDEzVnFPOnkxB33x/GST4aBgLLTunge7WS5JF2hQ3ONKLFkKLIKbyJhXmhUpSMF1KkR+XGrlS9cppijhc8gm3zR7zz53tBOcilwh8ttNZhf45JmZVrrPdnbyyMNimrpvkojPjZxW/A/aUObv6CQ1qY0HKU7CjR7ZKTVF75mS205cpy8XMcSh/cHb4ePt9BLijjBx9cq0aOnPJa0tt/kv7zefUyDmQkMBJAEOEbjYI1ekCgkKPwqVMRSZp7oZOP0fcp6FebSJjN2S5IcaC10VrkrAKszDlo5Af5ysEU7nDHAybVY1JdXV6QiKBnsigK36QkfnPFVbKxNs1n3ltkUn2jdcM98LzfTaSxUUSnH/jSkbkXhlek98czFB9dvwM0DWI0xZdw71qnH/eUpiBzSJVPIQCGBTwIBEXAlZRs77m/A6w== alx@alx-laptop.local
            EOT
        }
      + name                      = "vm0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8smb7fj0o91i68s15v"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm[1] will be created
  + resource "yandex_compute_instance" "vm" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD3R9Y4b0XAtt4uh0TYmWM+OVMHNuHEljZLMMSfPEt/NDgLL9b60GF9YTTIMy8t9PJEo0dFU+Pw8Xqe8PSVqmCPMOEC/vEhfViayYFFC8ntDdFyt8wn4NntKQYX5etRTssWiq7D1lhVhK5rkpJeXhjguJZGT0NexOU0nKVYQj0PuSK5UlZUeMQa7b8V/4N8EsfAK6iOV+3iEafcrYYkgysN+fVB0DZT4YPlPXxIN+eXpKVfNYC9TXyhz8pX1VNoBDEzVnFPOnkxB33x/GST4aBgLLTunge7WS5JF2hQ3ONKLFkKLIKbyJhXmhUpSMF1KkR+XGrlS9cppijhc8gm3zR7zz53tBOcilwh8ttNZhf45JmZVrrPdnbyyMNimrpvkojPjZxW/A/aUObv6CQ1qY0HKU7CjR7ZKTVF75mS205cpy8XMcSh/cHb4ePt9BLijjBx9cq0aOnPJa0tt/kv7zefUyDmQkMBJAEOEbjYI1ekCgkKPwqVMRSZp7oZOP0fcp6FebSJjN2S5IcaC10VrkrAKszDlo5Af5ysEU7nDHAybVY1JdXV6QiKBnsigK36QkfnPFVbKxNs1n3ltkUn2jdcM98LzfTaSxUUSnH/jSkbkXhlek98czFB9dvwM0DWI0xZdw71qnH/eUpiBzSJVPIQCGBTwIBEXAlZRs77m/A6w== alx@alx-laptop.local
            EOT
        }
      + name                      = "vm1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8smb7fj0o91i68s15v"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm2["vm01"] will be created
  + resource "yandex_compute_instance" "vm2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD3R9Y4b0XAtt4uh0TYmWM+OVMHNuHEljZLMMSfPEt/NDgLL9b60GF9YTTIMy8t9PJEo0dFU+Pw8Xqe8PSVqmCPMOEC/vEhfViayYFFC8ntDdFyt8wn4NntKQYX5etRTssWiq7D1lhVhK5rkpJeXhjguJZGT0NexOU0nKVYQj0PuSK5UlZUeMQa7b8V/4N8EsfAK6iOV+3iEafcrYYkgysN+fVB0DZT4YPlPXxIN+eXpKVfNYC9TXyhz8pX1VNoBDEzVnFPOnkxB33x/GST4aBgLLTunge7WS5JF2hQ3ONKLFkKLIKbyJhXmhUpSMF1KkR+XGrlS9cppijhc8gm3zR7zz53tBOcilwh8ttNZhf45JmZVrrPdnbyyMNimrpvkojPjZxW/A/aUObv6CQ1qY0HKU7CjR7ZKTVF75mS205cpy8XMcSh/cHb4ePt9BLijjBx9cq0aOnPJa0tt/kv7zefUyDmQkMBJAEOEbjYI1ekCgkKPwqVMRSZp7oZOP0fcp6FebSJjN2S5IcaC10VrkrAKszDlo5Af5ysEU7nDHAybVY1JdXV6QiKBnsigK36QkfnPFVbKxNs1n3ltkUn2jdcM98LzfTaSxUUSnH/jSkbkXhlek98czFB9dvwM0DWI0xZdw71qnH/eUpiBzSJVPIQCGBTwIBEXAlZRs77m/A6w== alx@alx-laptop.local
            EOT
        }
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8smb7fj0o91i68s15v"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm2["vm02"] will be created
  + resource "yandex_compute_instance" "vm2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDD3R9Y4b0XAtt4uh0TYmWM+OVMHNuHEljZLMMSfPEt/NDgLL9b60GF9YTTIMy8t9PJEo0dFU+Pw8Xqe8PSVqmCPMOEC/vEhfViayYFFC8ntDdFyt8wn4NntKQYX5etRTssWiq7D1lhVhK5rkpJeXhjguJZGT0NexOU0nKVYQj0PuSK5UlZUeMQa7b8V/4N8EsfAK6iOV+3iEafcrYYkgysN+fVB0DZT4YPlPXxIN+eXpKVfNYC9TXyhz8pX1VNoBDEzVnFPOnkxB33x/GST4aBgLLTunge7WS5JF2hQ3ONKLFkKLIKbyJhXmhUpSMF1KkR+XGrlS9cppijhc8gm3zR7zz53tBOcilwh8ttNZhf45JmZVrrPdnbyyMNimrpvkojPjZxW/A/aUObv6CQ1qY0HKU7CjR7ZKTVF75mS205cpy8XMcSh/cHb4ePt9BLijjBx9cq0aOnPJa0tt/kv7zefUyDmQkMBJAEOEbjYI1ekCgkKPwqVMRSZp7oZOP0fcp6FebSJjN2S5IcaC10VrkrAKszDlo5Af5ysEU7nDHAybVY1JdXV6QiKBnsigK36QkfnPFVbKxNs1n3ltkUn2jdcM98LzfTaSxUUSnH/jSkbkXhlek98czFB9dvwM0DWI0xZdw71qnH/eUpiBzSJVPIQCGBTwIBEXAlZRs77m/A6w== alx@alx-laptop.local
            EOT
        }
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8smb7fj0o91i68s15v"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_iam_service_account.sa will be created
  + resource "yandex_iam_service_account" "sa" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + name       = "sa"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1gepbnbb2dpav1bstcs"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.netology-bucket1 will be created
  + resource "yandex_storage_bucket" "netology-bucket1" {
      + access_key            = "YPBJEb6CEHfbL2JdRCJh4iBhK"
      + acl                   = "private"
      + bucket                = "netology-bucket1"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = (known after apply)
          + read = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

  # yandex_vpc_network.network01 will be created
  + resource "yandex_vpc_network" "network01" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network01"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet01 will be created
  + resource "yandex_vpc_subnet" "subnet01" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet01"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = (known after apply)
    }

Plan: 10 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee
to take exactly these actions if you run "terraform apply" now.
```
