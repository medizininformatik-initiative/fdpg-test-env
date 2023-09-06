resource "hcloud_ssh_key" "akiel" {
  name       = "Alexander Kiel"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXNWbPLgh2qbRY5h20MzK6ezuYqYFNW1uDbkXehsX0/9eWY8+W0lh/LN6qOhx0/SDhZS1m2HM1HXpK9rbgkx0CejW+Di6sAOE52/6r9d4q4LshxjSjQvn0YAulu7ErwAoTJgFcOcUf8GXMU0FbSUgSBiwjD/TUHw30ywWmDqWtR2YzZH5qYZMlDaoh3RXxZGbNc1t3YOpIAUXutJUzHn4ekG4OltF8Wc2uHfr+Q0jAwi4zthhNMnZ8cgLHze1AMRV/QvzPG/h6TQ+A2vhMSo9lCV0eRH/dg6dADSHNoQxFHB/7Z7VHXZZoOhD4L8W8P7rWnbeVevYw9enZECxdCqLR alexanderkiel@gmx.net"
}

data "hcloud_ssh_key" "mruehle" {
  name       = "Mathias Rühle"
}

data "hcloud_ssh_key" "jgruendner" {
  name       = "Julian Gruendner"
}

data "hcloud_ssh_key" "rwettstein" {
  name       = "Reto Wettstein"
}

module "diz" {
  source   = "./modules/diz"
  number   = count.index + 1
  ssh_keys = [
    hcloud_ssh_key.akiel.id,
    data.hcloud_ssh_key.mruehle.id,
    data.hcloud_ssh_key.jgruendner.id,
    data.hcloud_ssh_key.rwettstein.id
  ]
  count    = terraform.workspace == "default" ? 2 : 0
}

module "fdpg" {
  source   = "./modules/fdpg"
  ssh_keys = [
    hcloud_ssh_key.akiel.id,
    data.hcloud_ssh_key.mruehle.id,
    data.hcloud_ssh_key.jgruendner.id,
    data.hcloud_ssh_key.rwettstein.id
  ]
}

module "dms" {
  source   = "./modules/dms"
  ssh_keys = [hcloud_ssh_key.akiel.id, data.hcloud_ssh_key.mruehle.id, data.hcloud_ssh_key.jgruendner.id]
}

module "monitoring" {
  source   = "./modules/monitoring"
  ssh_keys = [hcloud_ssh_key.akiel.id, data.hcloud_ssh_key.mruehle.id, data.hcloud_ssh_key.jgruendner.id]
  count    = terraform.workspace == "default" ? 1 : 0
}

module "perf_test" {
  source   = "./modules/perf-test"
  ssh_keys = [hcloud_ssh_key.akiel.id, data.hcloud_ssh_key.mruehle.id, data.hcloud_ssh_key.jgruendner.id]
  count    = terraform.workspace == "default" ? 1 : 0
}
