variable "project" {
  type        = string
  description = "Personal project id. The project indicates the default GCP project all of your resources will be created in."
  default     = "chkp-tf-project"
}

variable "prefix" {
  type        = string
  description = "Resources name prefix"
  default     = "chkp-tf-pi"
}

variable "network" {
  type        = string
  description = "The name or self_link of the network"
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the subnetwork"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "ip_protocol" {
  description = "The IP protocol to which this rule applies. For protocol forwarding, valid options are TCP, UDP, ESP, AH, SCTP, ICMP and L3_DEFAULT."
  default     = "TCP"
  type        = string
}

variable "ports" {
  description = "Which port numbers are forwarded to the backends"
  default     = []
  type        = list(number)
}

variable "protocol" {
  description = "The protocol used by the backend service. Valid values are HTTP, HTTPS, HTTP2, SSL, TCP, UDP, GRPC, UNSPECIFIED"
  default     = "TCP"
  type        = string
  
}

variable "instance_group" {
  description = "The name or self_link of the instance group"
  type        = string
}
