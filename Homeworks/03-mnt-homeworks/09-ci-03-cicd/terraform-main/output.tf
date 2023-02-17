output "internal_ip_address_sonar-01_yandex_cloud" {
  value = yandex_compute_instance.sonar-01.network_interface.0.ip_address
}

output "external_ip_address_sonar-01_yandex_cloud" {
  value = yandex_compute_instance.sonar-01.network_interface.0.nat_ip_address
}

output "internal_ip_address_nexus-01_yandex_cloud" {
  value = yandex_compute_instance.nexus-01.network_interface.0.ip_address
}

output "external_ip_address_nexus-01_yandex_cloud" {
  value = yandex_compute_instance.nexus-01.network_interface.0.nat_ip_address
}
