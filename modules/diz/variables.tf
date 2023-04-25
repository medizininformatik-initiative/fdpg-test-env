variable "number" {
  type = number
  description = "the DIZ number starting with 1"
}

variable "ssh_keys" {
  type = list(number)
  description = "the ID's of hcloud_ssh_key resources"
}
