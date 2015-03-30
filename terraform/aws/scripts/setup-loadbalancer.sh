#!/bin/bash

main() {
  local node=$(ec2_hostname "$1")
  local private_dns="$2"
  local atlas_token="$3"
  local atlas_infrastructure="$4"
  wait_ssh_ready "$node"

  set_consul_atlas "$node" "$atlas_token" "$atlas_infrastructure"
  register_service "$node" consul
  register_service "$node" docker
  register_service "$node" haproxy
}