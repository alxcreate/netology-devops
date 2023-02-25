output "internal_ip_address_jenkins-agent-01_yandex_cloud" {
  value = yandex_compute_instance.jenkins-agent-01.network_interface.0.ip_address
}

output "external_ip_address_jenkins-agent-01_yandex_cloud" {
  value = yandex_compute_instance.jenkins-agent-01.network_interface.0.nat_ip_address
}

output "internal_ip_address_jenkins-master-01_yandex_cloud" {
  value = yandex_compute_instance.jenkins-master-01.network_interface.0.ip_address
}

output "external_ip_address_jenkins-master-01_yandex_cloud" {
  value = yandex_compute_instance.jenkins-master-01.network_interface.0.nat_ip_address
}
