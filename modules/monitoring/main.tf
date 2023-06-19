resource "hcloud_primary_ip" "monitoring" {
  name          = "monitoring"
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

#resource "hcloud_server" "monitoring" {
#  name         = "monitoring"
#  image        = "ubuntu-22.04"
#  server_type  = "cx21"
#  datacenter   = "fsn1-dc14"
#  ssh_keys     = var.ssh_keys
#
#  public_net {
#    ipv4         = hcloud_primary_ip.monitoring.id
#    ipv4_enabled = true
#    ipv6_enabled = true
#  }
#}
