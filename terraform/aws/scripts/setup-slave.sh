#!/bin/bash

main() {
  local node=$(ec2_hostname "$1")
  local public_dns="$2"
  wait_ssh_ready "$node"

  set_mesos_zk "$node"
  set_mesos_slave_hostname "$node" "$public_dns"
  register_service "$node" mesos-slave
  register_service "$node" docker
}
