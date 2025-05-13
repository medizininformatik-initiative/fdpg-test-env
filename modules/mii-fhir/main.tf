resource "hcloud_firewall" "mii_fhir" {
  name = "mii-fhir-dmz"
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_primary_ip" "mii_fhir" {
  name          = "mii-fhir"
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "mii_fhir" {
  name         = "mii-fhir"
  image        = "ubuntu-24.04"
  server_type  = "cax31"
  datacenter   = "fsn1-dc14"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.mii_fhir.id]

  public_net {
    ipv4         = hcloud_primary_ip.mii_fhir.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
