output "internal_ip_address_master_yandex_cloud" {
  value = yandex_compute_instance.master.network_interface.0.ip_address
}

output "external_ip_address_master_yandex_cloud" {
  value = yandex_compute_instance.master.network_interface.0.nat_ip_address
}

output "internal_ip_address_node1_yandex_cloud" {
  value = yandex_compute_instance.node1.network_interface.0.ip_address
}

output "external_ip_address_node1_yandex_cloud" {
  value = yandex_compute_instance.node1.network_interface.0.nat_ip_address
}

output "internal_ip_address_node2_yandex_cloud" {
  value = yandex_compute_instance.node2.network_interface.0.ip_address
}

output "external_ip_address_node2_yandex_cloud" {
  value = yandex_compute_instance.node2.network_interface.0.nat_ip_address
}

output "internal_ip_address_node3_yandex_cloud" {
  value = yandex_compute_instance.node3.network_interface.0.ip_address
}

output "external_ip_address_node3_yandex_cloud" {
  value = yandex_compute_instance.node3.network_interface.0.nat_ip_address
}

output "internal_ip_address_node4_yandex_cloud" {
  value = yandex_compute_instance.node4.network_interface.0.ip_address
}

output "external_ip_address_node4_yandex_cloud" {
  value = yandex_compute_instance.node4.network_interface.0.nat_ip_address
}
