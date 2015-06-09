/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-slave" {
  name    = "${var.atlas_artifact.slave}"
  type    = "googlecompute.image"
  version = "${var.atlas_artifact_version.slave}"
}

resource "google_compute_instance" "mesos-slave" {
    count        = "${var.slaves}"
    name         = "apollo-mesos-slave-${count.index}"
    machine_type = "${var.instance_type.slave}"
    zone         = "${var.zone}"
    tags         = ["mesos-slave","http","https","ssh"]

    disk {
      image = "${atlas_artifact.mesos-slave.id}"
    }
    
    metadata {
      role = "mesos_slaves"
    }

    network_interface {
      network = "default"
        access_config {
            // Ephemeral IP
        }
    }   
}