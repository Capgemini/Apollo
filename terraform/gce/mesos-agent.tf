/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-agent" {
  name    = "${var.atlas_artifact.agent}"
  type    = "googlecompute.image"
  version = "${var.atlas_artifact_version.agent}"
}

module "traefik-ca" {
  source            = "github.com/Capgemini/tf_tls//ca"
  organization      = "${var.organization}"
  ca_count          = "${var.agents}"
  ip_addresses_list = "${concat(google_compute_instance.mesos-agent.*.network_interface.0.access_config.0.nat_ip)}"
  ssh_user          = "core"
  ssh_private_key   = "${tls_private_key.ssh.private_key_pem}"
  target_folder     = "/etc/traefik/ssl"
}

resource "google_compute_instance" "mesos-agent" {
    count        = "${var.agents}"
    name         = "apollo-mesos-agent-${count.index}"
    machine_type = "${var.instance_type.agent}"
    zone         = "${var.zone}"
    tags         = ["mesos-agent","http","https","ssh"]

    disk {
      image = "${atlas_artifact.mesos-agent.id}"
    }
    
    metadata {
      role = "mesos_agents"
    }

    network_interface {
      network = "default"
        access_config {
            // Ephemeral IP
        }
    }   
}
