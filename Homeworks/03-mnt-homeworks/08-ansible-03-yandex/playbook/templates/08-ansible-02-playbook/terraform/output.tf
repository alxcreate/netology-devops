output "internal_ip_address_clickhouse-01_yandex_cloud" {
  value = yandex_compute_instance.clickhouse-01.network_interface.0.ip_address
}

output "external_ip_address_clickhouse-01_yandex_cloud" {
  value = yandex_compute_instance.clickhouse-01.network_interface.0.nat_ip_address
}
