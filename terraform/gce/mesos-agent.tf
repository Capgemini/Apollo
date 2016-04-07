/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-agent" {
  name    = "${var.atlas_artifact.agent}"
  type    = "googlecompute.image"
  version = "${var.atlas_artifact_version.agent}"
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
