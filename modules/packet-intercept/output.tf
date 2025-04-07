output "external_network_name" {
  value = module.external_network_and_subnet.new_created_network_name
}
output "external_subnetwork_name" {
  value = module.external_network_and_subnet.new_created_subnet_name
}
output "internal_network_name" {
  value = module.internal_network_and_subnet.new_created_network_name
}
output "internal_subnetwork_name" {
  value = module.internal_network_and_subnet.new_created_subnet_name
}
output "network_ICMP_firewall_rule" {
  value = module.network_ICMP_firewall_rules[*].firewall_rule_name
}
output "network_TCP_firewall_rule" {
  value = module.network_TCP_firewall_rules[*].firewall_rule_name
}
output "network_UDP_firewall_rule" {
  value = module.network_UDP_firewall_rules[*].firewall_rule_name
}
output "network_SCTP_firewall_rule" {
  value = module.network_SCTP_firewall_rules[*].firewall_rule_name
}
output "network_ESP_firewall_rule" {
  value = module.network_ESP_firewall_rules[*].firewall_rule_name
}
output "management_name"{
  value = module.packet-intercept.configuration_template_name
}
output "instance_template_name"{
  value = module.packet-intercept.instance_template_name
}
output "instance_group_manager_name"{
  value = module.packet-intercept.instance_group_manager_name
}
output "autoscaler_name"{
  value = module.packet-intercept.autoscaler_name
}