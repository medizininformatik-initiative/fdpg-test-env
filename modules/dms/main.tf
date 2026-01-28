resource "hcloud_firewall" "dms" {
  name = terraform.workspace == "default" ? "dms-dmz" : format("%s-dms-dmz", terraform.workspace)
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

resource "hcloud_primary_ip" "dsf_fhir" {
  name          = terraform.workspace == "default" ? "dms-dsf-fhir" : format("%s-dms-dsf-fhir", terraform.workspace)
  type          = "ipv4"
  datacenter    = "nbg1-dc3"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "dsf_fhir" {
  name         = terraform.workspace == "default" ? "dms-dsf-fhir" : format("%s-dms-dsf-fhir", terraform.workspace)
  image        = "ubuntu-24.04"
  server_type  = "cx33"
  datacenter   = "nbg1-dc3"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.dms.id]

  public_net {
    ipv4         = hcloud_primary_ip.dsf_fhir.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
