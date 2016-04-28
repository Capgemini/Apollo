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

variable "vn_cidr_block" { 
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

variable "storage_container_name" { 
    description = "Storage container name" 
    default = "mesosimages-container" 
} 