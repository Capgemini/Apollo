
/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name    = "${var.atlas_artifact.master}"
  type    = "googlecompute.image"
  version = "${var.atlas_artifact_version.master}"
}

resource "google_compute_instance" "mesos-master" {
    count        = "${var.masters}"
    name         = "apollo-mesos-master-${count.index}"
    machine_type = "${var.instance_type.master}"
    zone         = "${var.zone}"
    tags         = ["mesos-master"]
    
    disk {
      image = "${atlas_artifact.mesos-master.id}"
    }

    # declare metadata for configuration of the node
    metadata {
      role = "mesos_masters"
    }
    
    network_interface {
      network = "default"
        access_config {
            // Ephemeral IP
        }
    }   
}

resource "google_compute_firewall" "default" {
    name    = "default-allow-all"
    network = "default"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports    = ["1-65535"]
    }

    allow {
        protocol = "udp"
        ports    = ["1-65535"]
    }

    source_ranges = ["0.0.0.0/0"]
}
