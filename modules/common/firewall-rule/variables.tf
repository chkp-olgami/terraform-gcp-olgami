variable "protocol" {
  type = string
  description = "The IP protocol to which this rule applies."
}
variable "source_ranges" {
  type = list(string)
  description = "(Optional) Source IP ranges for the protocol traffic - Traffic is only allowed from sources within these IP address ranges. Use CIDR notation when entering ranges. For gateway only. Please leave empty list to unable this protocol traffic."
  default = []
}
variable "rule_name" {
  type = string
  description = "Firewall rule name."
}
variable "network" {
  type = list(string)
  description = "The name or self_link of the network to attach this firewall to."
}
variable "target_tags" {
  description = "List of target tags for the firewall rule"
  type = list(string)
  default = ["checkpoint-gateway"]
}
variable "ports" {
  description = "List of ports to which this rule applies. This field is only applicable for UDP or TCP protocol. "
  type = list(number)
  default = []
  
}