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

variable "location" { 
	description = "The deployment azure data centre location." 
}

variable "vn_cidr_block" { 
	description = "Cidr block for the VN." 
} 
 
variable "subnet_cidr_block" { 
	description = "CIDR for private subnet" 
} 

