resource "hcloud_firewall" "dmz" {
  name = terraform.workspace == "default" ? format("diz-%d-dmz", var.number) : format("%s-diz-%d-dsf-dmz", terraform.workspace, var.number)
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

resource "hcloud_firewall" "intern" {
  name = terraform.workspace == "default" ? format("diz-%d-intern", var.number) : format("%s-diz-%d-dsf-intern", terraform.workspace, var.number)
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
  name     = terraform.workspace == "default" ? format("diz-%d-intern", var.number) : format("%s-diz-%d-dsf-intern", terraform.workspace, var.number)
  ip_range = "10.0.0.0/24"
}

resource "hcloud_network_subnet" "intern" {
  type         = "cloud"
  network_id   = hcloud_network.intern.id
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}

resource "hcloud_primary_ip" "dsf_fhir" {
  name          = terraform.workspace == "default" ? format("diz-%d-dsf-fhir", var.number) : format("%s-diz-%d-dsf-fhir", terraform.workspace, var.number)
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "dsf_fhir" {
  name         = terraform.workspace == "default" ? format("diz-%d-dsf-fhir", var.number) : format("%s-diz-%d-dsf-fhir", terraform.workspace, var.number)
  image        = "ubuntu-22.04"
  server_type  = "cpx21"
  datacenter   = "fsn1-dc14"
  ssh_keys     = var.ssh_keys
  firewall_ids = [hcloud_firewall.dmz.id]

  public_net {
    ipv4         = hcloud_primary_ip.dsf_fhir.id
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_primary_ip" "dsf_bpe" {
  name          = terraform.workspace == "default" ? format("diz-%d-dsf-bpe", var.number) : format("%s-diz-%d-dsf-bpe", terraform.workspace, var.number)
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_primary_ip" "triangle" {
  name          = terraform.workspace == "default" ? format("diz-%d-triangle", var.number) : format("%s-diz-%d-dsf-triangle", terraform.workspace, var.number)
  type          = "ipv4"
  datacenter    = "fsn1-dc14"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "dsf_bpe" {
  name         = terraform.workspace == "default" ? format("diz-%d-dsf-bpe", var.number) : format("%s-diz-%d-dsf-bpe", terraform.workspace, var.number)
  image        = "ubuntu-22.04"
  server_type  = "cx22"
  datacenter   = "fsn1-dc14"
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
  name        = terraform.workspace == "default" ? format("diz-%d-triangle", var.number) : format("%s-diz-%d-dsf-triangle", terraform.workspace, var.number)
  image       = "ubuntu-22.04"
  server_type = "cx21"
  datacenter  = "fsn1-dc14"
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
