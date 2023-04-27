resource "hcloud_firewall" "fdpg" {
  name = "fdpg"
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

resource "hcloud_primary_ip" "fdpg" {
  name          = "fdpg"
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "fdpg" {
  name         = "fdpg"
  image        = "ubuntu-22.04"
  server_type  = "cx41"
  datacenter   = "fsn1-dc14"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.fdpg.id]

  public_net {
    ipv4         = hcloud_primary_ip.fdpg.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_primary_ip" "fdpg_keycloak" {
  name          = "fdpg-keycloak"
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "fdpg-keycloak" {
  name         = "fdpg-keycloak"
  image        = "ubuntu-22.04"
  server_type  = "cx11"
  datacenter   = "fsn1-dc14"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.fdpg.id]

  public_net {
    ipv4         = hcloud_primary_ip.fdpg_keycloak.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
