variable "subscription_id" { 
	description = "The Azure subscrition identifier (guid)." 
} 

variable "client_id" { 
	description = "The oAuth 2 client id. " 
} 

variable "client_secret" { 
	description = "The oAuth 2 client secret." 
}

variable "tenant_id" { 
	description = "The oAuth 2 tenant id." 
}

variable "region" { 
	description = "The deployment azure data centre location." 
	default = "North Europe"
}

variable "vpc_cidr_block" { 
	description = "Cidr block for the VN." 
	default = "10.0.0.0/16"
} 
 
variable "subnet_cidr_block" { 
	description = "CIDR for private subnet" 
	default     = "10.0.0.0/24"
} 

variable "storage_account_name" { 
    	description = "Storage account name" 
    	default = "mesosimages" 
} 

variable "storage_account_type" { 
    	description = "Storage account type" 
}

variable "storage_container_name" { 
    	description = "Storage container name" 
    	default = "mesosimages-container" 
} 

variable "artifact_bastion" { 
	default = { 
		publisher = "CoreOS"
		offer ="CoreOS"
		"sku" = "Stable"
		"version" = "latest"	 
	}
} 

variable "artifact_master" { 
	default = { 
		publisher = "CoreOS"
		offer ="CoreOS"
		"sku" = "Stable"
		"version" = "latest"	 
	}
} 

variable "artifact_agent" { 
	default = { 
		publisher = "CoreOS"
		offer ="CoreOS"
		"sku" = "Stable"
		"version" = "latest"	 
	}
} 

variable "instance_type" { 
	default = { 
	master = "Standard_A0" 
	agent  = "Standard_A0" 
	} 
} 

variable "bastion_server_computername" { 
	description = "Username to access server"
	default = "bastion"
} 

variable "bastion_server_username" { 
	description = "Username to access server"
} 

variable "bastion_server_password" { 
	description = "Password to access server"
} 

variable "master_server_username" { 
	description = "Username to access master server"
} 

variable "master_server_password" { 
	description = "Password to access master server"
} 

variable "agent_server_username" { 
	description = "Username to access agent server"
} 

variable "agent_server_password" { 
	description = "Password to access agent server"
} 
  
variable "master_count" { 
	description = "The number of masters." 
    	default = "1" 
} 

variable "agent_count" { 
	description = "The number of agents." 
    	default = "1" 
} 

variable "docker_version" { 
	description = "Docker version" 
	default = "1.9.0-0~trusty" 
} 

variable "ssh_public_key_file" { 
	description = "Public key required to connect via ssh"
} 

variable "ssh_private_key_file" { 
	description = "Public key required to connect via ssh"
} 
