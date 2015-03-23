#!/bin/bash

main() {
  local node=$(ec2_hostname "$1")
  local private_dns="$2"
  local atlas_token="$3"
  local atlas_infrastructure="$4"
  wait_ssh_ready "$node"

  set_mesos_master_quorum "$node"
  set_consul_atlas "$node" "$atlas_token" "$atlas_infrastructure"
  set_consul_master "$node"
  set_zookeeper_myid "$node"
  set_zookeeper_cfg "$node"
  set_mesos_zk "$node"
  set_mesos_master_hostname "$node" "$private_dns"
  register_service "$node" zookeeper
  register_service "$node" mesos-master
  register_service "$node" marathon
  register_service "$node" consul
  register_service "$node" dnsmasq
}
