resource "hcloud_primary_ip" "perf_test" {
  name          = "perf-test"
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

#resource "hcloud_server" "perf_test" {
#  name         = "perf-test"
#  image        = "ubuntu-24.04"
#  server_type  = "cax31"
#  datacenter   = "fsn1-dc14"
#  ssh_keys     = var.ssh_keys
#
#  public_net {
#    ipv4         = hcloud_primary_ip.perf_test.id
#    ipv4_enabled = true
#    ipv6_enabled = true
#  }
#}

resource "hcloud_volume" "test_data" {
  name      = "test-data"
  size      = 512
  location  = "fsn1"
  format    = "ext4"
}

#resource "hcloud_volume_attachment" "perf_test_test_data" {
#  server_id = hcloud_server.perf_test.id
#  volume_id = hcloud_volume.test_data.id
#  automount = true
#}
