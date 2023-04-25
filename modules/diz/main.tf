resource "hcloud_firewall" "dmz" {
  name = format("diz-%d-dmz", var.number)
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
    port       = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_firewall" "intern" {
  name = format("diz-%d-intern", var.number)
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_network" "intern" {
  name     = format("diz-%d-intern", var.number)
  ip_range = "10.0.0.0/24"
}

resource "hcloud_network_subnet" "intern" {
  type         = "cloud"
  network_id   = hcloud_network.intern.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}

resource "hcloud_primary_ip" "dsf_fhir" {
  name          = format("diz-%d-dsf-fhir", var.number)
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "dsf_fhir" {
  name         = format("diz-%d-dsf-fhir", var.number)
  image        = "ubuntu-22.04"
  server_type  = "cx11"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.dmz.id]

  public_net {
    ipv4         = hcloud_primary_ip.dsf_fhir.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_primary_ip" "dsf_bpe" {
  name          = format("diz-%d-dsf-bpe", var.number)
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_primary_ip" "triangle" {
  name          = format("diz-%d-triangle", var.number)
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "dsf_bpe" {
  name         = format("diz-%d-dsf-bpe", var.number)
  image        = "ubuntu-22.04"
  server_type  = "cx11"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.intern.id]

  network {
    network_id = hcloud_network.intern.id
    ip         = "10.0.0.2"
  }

  public_net {
    ipv4         = hcloud_primary_ip.dsf_bpe.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_server" "triangle" {
  name        = format("diz-%d-triangle", var.number)
  image       = "ubuntu-22.04"
  server_type = "cx31"
  ssh_keys    = var.ssh_keys

  network {
    network_id = hcloud_network.intern.id
    ip         = "10.0.0.3"
  }

  public_net {
    ipv4         = hcloud_primary_ip.triangle.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
