#!/bin/bash

main() {
  local node=$(ec2_hostname "$1")
  local private_dns="$2"
  local atlas_token="$3"
  local atlas_infrastructure="$4"
  local host_index="$5"
  local region="$6"

  wait_ssh_ready "$node"

  set_mesos_zk "$node"
  set_mesos_slave_hostname "$node" "$private_dns"
  set_consul_atlas "$node" "$atlas_token" "$atlas_infrastructure" "$region"
  register_service "$node" mesos-slave
  register_service "$node" docker
  register_service "$node" consul
  register_service "$node" dnsmasq
  set_weave_bridge "$node" "$host_index"
  run_serverspecs "$node" mesos-slave
}
