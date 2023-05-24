data "hcloud_ssh_key" "akiel" {
  name       = "Alexander Kiel"
}

data "hcloud_ssh_key" "mruehle" {
  name       = "Mathias Rühle"
}

data "hcloud_ssh_key" "jgruendner" {
  name       = "Julian Gruendner"
}

module "diz" {
  source   = "./modules/diz"
  number   = count.index + 1
  ssh_keys = [data.hcloud_ssh_key.akiel.id, data.hcloud_ssh_key.mruehle.id, data.hcloud_ssh_key.jgruendner.id]
  count    = terraform.workspace == "default" ? 1 : 0
}

module "fdpg" {
  source   = "./modules/fdpg"
  ssh_keys = [data.hcloud_ssh_key.akiel.id, data.hcloud_ssh_key.mruehle.id, data.hcloud_ssh_key.jgruendner.id]
}

module "perf_test" {
  source   = "./modules/perf-test"
  ssh_keys = [data.hcloud_ssh_key.akiel.id, data.hcloud_ssh_key.mruehle.id, data.hcloud_ssh_key.jgruendner.id]
  count    = terraform.workspace == "default" ? 1 : 0
}
