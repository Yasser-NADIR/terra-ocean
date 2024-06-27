terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "master_node_count" {
  type = number
  default = 1
}

variable "worker_node_count" {
  type = number
  default = 0
}

resource "digitalocean_ssh_key" "node_ssh" {
  name       = "node-ssh"
  public_key = file("id_droplet.pub")
}

resource "digitalocean_droplet" "master" {
  count = var.master_node_count
  image  = "ubuntu-24-04-x64"
  name   = "master-${count.index}"
  region = "nyc1"
  size   = "s-1vcpu-2gb-70gb-intel"
  ssh_keys = [
    digitalocean_ssh_key.node_ssh.fingerprint
  ]
}

resource "digitalocean_droplet" "worker" {
  count = var.worker_node_count
  image  = "ubuntu-24-04-x64"
  name   = "worker-${count.index}"
  region = "nyc1"
  size   = "s-1vcpu-2gb-70gb-intel"
  ssh_keys = [
    digitalocean_ssh_key.node_ssh.fingerprint
  ]
}

output "master_ipv4" {
  value = digitalocean_droplet.master.*.ipv4_address
}

output "worker_ipv4" {
  value = digitalocean_droplet.worker.*.ipv4_address
}