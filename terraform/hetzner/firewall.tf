resource "hcloud_firewall" "voidbound_edge" {
  name = "fw-voidbound-edge"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"

    source_ips = [
      "188.117.196.60/32",
      "149.107.52.42/32",
    ]
  }

  rule {
    direction = "in"
    protocol  = "icmp"

    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"

    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"

    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
  }

  apply_to {
    server = hcloud_server.voidbound_edge.id
  }

  lifecycle {
    prevent_destroy = true
  }
}
