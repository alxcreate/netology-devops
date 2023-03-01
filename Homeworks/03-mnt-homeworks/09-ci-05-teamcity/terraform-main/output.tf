#output "internal_ip_address_teamcity-agent_yandex_cloud" {
#  value = yandex_compute_instance.teamcity-agent.network_interface.0.ip_address
#}

#output "external_ip_address_teamcity-agent_yandex_cloud" {
#  value = yandex_compute_instance.teamcity-agent.network_interface.0.nat_ip_address
#}

#output "internal_ip_address_teamcity-server_yandex_cloud" {
#  value = yandex_compute_instance.teamcity-server.network_interface.0.ip_address
#}

#output "external_ip_address_teamcity-server_yandex_cloud" {
#  value = yandex_compute_instance.teamcity-server.network_interface.0.nat_ip_address
#}

output "internal_ip_address_vm_yandex_cloud" {
  value = yandex_compute_instance.vm.network_interface.0.ip_address
}

output "external_ip_address_vm_yandex_cloud" {
  value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
}
