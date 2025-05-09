resource "google_compute_firewall" "firewall_rules" {
  name = var.rule_name
  network = var.network[0]
  allow {
    protocol = var.protocol
    ports = var.ports
  }
  source_ranges = var.source_ranges
  target_tags = var.target_tags
}