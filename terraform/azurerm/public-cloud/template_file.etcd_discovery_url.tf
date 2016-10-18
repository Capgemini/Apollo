# Generate an etcd URL for the cluster 
resource "template_file" "etcd_discovery_url" { 
	# template = "${file(/dev/null)}" 
	provisioner "local-exec" { 
		command = "curl https://discovery.etcd.io/new?size=${var.master_count} > ${var.etcd_discovery_url_file}" 
	} 
	
	# This will regenerate the discovery URL if the cluster size changes, we include the bastion here 
   	vars { 
		size = "${var.master_count}" 
   	} 
} 
