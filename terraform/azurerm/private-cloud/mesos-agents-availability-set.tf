# Create an availability set for agent servers
resource "azurerm_availability_set" "agent" {
	name = "Agent_AvailabilitySet" 
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	location = "${var.region}"
}

# Mesos agent availability set outputs
output "mesos_agent_virtual_machine_ids" {
	value = "${azurerm_availability_set.agent.id}"
}