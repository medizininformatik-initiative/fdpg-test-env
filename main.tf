resource "hcloud_ssh_key" "akiel" {
  name       = "Alexander Kiel"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXNWbPLgh2qbRY5h20MzK6ezuYqYFNW1uDbkXehsX0/9eWY8+W0lh/LN6qOhx0/SDhZS1m2HM1HXpK9rbgkx0CejW+Di6sAOE52/6r9d4q4LshxjSjQvn0YAulu7ErwAoTJgFcOcUf8GXMU0FbSUgSBiwjD/TUHw30ywWmDqWtR2YzZH5qYZMlDaoh3RXxZGbNc1t3YOpIAUXutJUzHn4ekG4OltF8Wc2uHfr+Q0jAwi4zthhNMnZ8cgLHze1AMRV/QvzPG/h6TQ+A2vhMSo9lCV0eRH/dg6dADSHNoQxFHB/7Z7VHXZZoOhD4L8W8P7rWnbeVevYw9enZECxdCqLR alexanderkiel@gmx.net"
}

resource "hcloud_ssh_key" "mruehle" {
  name       = "Mathias Rühle"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD5CdDq6AyEiDIThvG924gpxO/h9hVq0KTxdkD8f0dXGWX//C83vAYlpydGblcE09MN9Pk8c7BnQQeFqrENZAyZxwbz1NWSAMO1bXpJW+I8a6TikC493ZTUE2eJ2IFWfrQkUmT0jKAWuNSdvSK+78D7VI4m4zMf8thJCfHRy+fQraNClAXWcvtNCtAOYLj4kKTfuXuFOCgdNE5H3/0Xbl8OUBQ910EfQ1Dfp49vMazWo9w97NPkWUtJP1zZDgunYa8oHSU3t/6BM9Gh05gVIFiTHJE+NDCunmnlcWgiufLeKJg4EwjB1kJNcoqTtdr8tKJb5Z8pL/t85yzKtSEx72Zl mruehle@life-511480"
}

resource "hcloud_ssh_key" "jgruendner" {
  name       = "Julian Gruendner"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjXGh5tJvLTgkI8Ftcagie0D82jCuO5zSpety0/M32PFFijqO1oB84bOgtZxXYCiqNiPnbNXz4V6yk7S4KzKX3nT5GQsOsISs33ZobR9YJwhAT8uFawXcEHgAui63KsL4xFJY4r6xvXxpKzmC8WYkyGxTd0VS45AvlvoLycy8tdky5a6ugtvzmUow8iRa7QlW1AGwug0TSWdRhe4NobE+pep+KUaSFnZbl/t9def8G1hC8pQBSafeHitHdPEjeJBcwgeg+z+twwZMU3+D3/q73H1mN9gn3ReJq5vp7G0UgXGUj6XyUlNCp0gfW4W5M0frKuXqBz825Brvub6uOxZBkxL0uaOF6qCX/LXdx5P1g2dEMyxIfuFxqz5n1URjKCArAOu3PP+BF7/PnZoo94x+2aDfM0iur7G0b9g0ICD5GwESsZKjcV2ONUR+l8bw+t05NCGcoZSBwkl6jQVHJI7lBjwtdP/yzVJrbxMvpH9vpINn+BzcaydYebNO3IbTvbA8nYl9Yjen2FZMTVbgri4YbWf39r934qnKcxnQMZDX9aY7sYDDja1P0E5PlDFZNJ3W8IlZvlL5gduvHXPkUYMW7f2Rp0v7SPv8AHWF9+v4JAOVCU2F7g9hsd4xm3fFZ1YoO94IYsJRMAc/C+6TroMvt8Nw7DBWq6WTGfmxDSAcdAw== juliangruendner@googlemail.com"
}

module "diz" {
  source = "./modules/diz"
  number = count.index + 1
  ssh_keys = [ hcloud_ssh_key.akiel.id, hcloud_ssh_key.mruehle.id, hcloud_ssh_key.jgruendner.id ]
  count = 1
}

module "fdpg" {
  source = "./modules/fdpg"
  ssh_keys = [ hcloud_ssh_key.akiel.id, hcloud_ssh_key.mruehle.id, hcloud_ssh_key.jgruendner.id ]
}
