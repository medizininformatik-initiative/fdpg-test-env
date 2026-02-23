resource "hcloud_firewall" "fdpg" {
  name = terraform.workspace == "default" ? "fdpg" : format("%s-fdpg", terraform.workspace)
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
  name          = terraform.workspace == "default" ? "fdpg" : format("%s-fdpg", terraform.workspace)
  type          = "ipv4"
  datacenter    = "nbg1-dc3"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "fdpg" {
  name         = terraform.workspace == "default" ? "fdpg" : format("%s-fdpg", terraform.workspace)
  image        = "ubuntu-24.04"
  server_type  = "cx33"
  datacenter   = "nbg1-dc3"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.fdpg.id]

  public_net {
    ipv4         = hcloud_primary_ip.fdpg.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_primary_ip" "fdpg_keycloak" {
  name          = terraform.workspace == "default" ? "fdpg-keycloak" : format("%s-fdpg-keycloak", terraform.workspace)
  type          = "ipv4"
  datacenter    = "nbg1-dc3"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "fdpg-keycloak" {
  name         = terraform.workspace == "default" ? "fdpg-keycloak" : format("%s-fdpg-keycloak", terraform.workspace)
  image        = "ubuntu-24.04"
  server_type  = "cx23"
  datacenter   = "nbg1-dc3"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.fdpg.id]

  public_net {
    ipv4         = hcloud_primary_ip.fdpg_keycloak.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
