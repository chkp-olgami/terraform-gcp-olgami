resource "google_compute_health_check" "health_check" {
  name               = "${var.prefix}-health-check"
  project            = var.project
  tcp_health_check {
    port = 8117
  }
}

resource "google_compute_region_backend_service" "backend_service" {
  name                  = "${var.prefix}-internal-backend-service"
  project               = var.project
  protocol              = var.protocol
  health_checks         = [google_compute_health_check.health_check.id]
  region                = var.region
  network               = var.network
  backend  {
    group = var.instance_group
  }
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "${var.prefix}-forwarding-rule"
  project               = var.project
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  ip_version            = "IPV4"
  ip_protocol           = var.ip_protocol
  ports                 = var.ports
  subnetwork            = var.subnetwork
  backend_service       = google_compute_region_backend_service.backend_service.self_link
}