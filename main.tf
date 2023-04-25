resource "hcloud_ssh_key" "akiel" {
  name       = "Alexander Kiel"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXNWbPLgh2qbRY5h20MzK6ezuYqYFNW1uDbkXehsX0/9eWY8+W0lh/LN6qOhx0/SDhZS1m2HM1HXpK9rbgkx0CejW+Di6sAOE52/6r9d4q4LshxjSjQvn0YAulu7ErwAoTJgFcOcUf8GXMU0FbSUgSBiwjD/TUHw30ywWmDqWtR2YzZH5qYZMlDaoh3RXxZGbNc1t3YOpIAUXutJUzHn4ekG4OltF8Wc2uHfr+Q0jAwi4zthhNMnZ8cgLHze1AMRV/QvzPG/h6TQ+A2vhMSo9lCV0eRH/dg6dADSHNoQxFHB/7Z7VHXZZoOhD4L8W8P7rWnbeVevYw9enZECxdCqLR alexanderkiel@gmx.net"
}

resource "hcloud_ssh_key" "mruehle" {
  name       = "Mathias Rühle"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD5CdDq6AyEiDIThvG924gpxO/h9hVq0KTxdkD8f0dXGWX//C83vAYlpydGblcE09MN9Pk8c7BnQQeFqrENZAyZxwbz1NWSAMO1bXpJW+I8a6TikC493ZTUE2eJ2IFWfrQkUmT0jKAWuNSdvSK+78D7VI4m4zMf8thJCfHRy+fQraNClAXWcvtNCtAOYLj4kKTfuXuFOCgdNE5H3/0Xbl8OUBQ910EfQ1Dfp49vMazWo9w97NPkWUtJP1zZDgunYa8oHSU3t/6BM9Gh05gVIFiTHJE+NDCunmnlcWgiufLeKJg4EwjB1kJNcoqTtdr8tKJb5Z8pL/t85yzKtSEx72Zl mruehle@life-511480"
}

module "diz" {
  source = "./modules/diz"
  number = count.index + 1
  ssh_keys = [ hcloud_ssh_key.akiel.id, hcloud_ssh_key.mruehle.id ]
  count = 1
}

module "fdpg" {
  source = "./modules/fdpg"
  ssh_keys = [ hcloud_ssh_key.akiel.id, hcloud_ssh_key.mruehle.id ]
}
