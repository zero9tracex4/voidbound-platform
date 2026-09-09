resource "hcloud_server" "voidbound_edge" {
  name        = "voidbound-edge"
  server_type = "cx23"
  image       = "ubuntu-26.04"
  location    = "nbg1"

  backups            = false
  delete_protection  = false
  rebuild_protection = false

  labels = {}

  lifecycle {
    prevent_destroy = true
  }
}
